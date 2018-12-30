use strict;
use warnings;
use JSON;
use List::Util qw(max min all);
use Clone qw(clone);

# A group has properties
#
# ty - type immune system/infection
# si - number of units
# hp - health point per unit
# ap - attack power
# at - attack type
# we - list of weaknesses (hash with keys like fire,poison,water mapping to null)
# im - immunities (hash with keys like fire,poison,water mapping to null)
# in - initiative
# ep - effective power

my @group = ();
my $current = '';
my $id = 1;
foreach my $line (<STDIN>) {
    if    ($line =~ m/Immune System/) {
        $id = 1;
        $current = 'immune';
    }
    elsif ($line =~ m/Infection/) {
        $id = 1;
        $current = 'infect';
    }
    else {
        my %new = ('id',$id++,'ty',$current);

        my ($si,$hp,$ap,$at,$in) = (0,0,0,0,0);
        # 18 units each with 729 hit points (weak to fire; immune to cold, slashing) with an attack that does 8 radiation damage at initiative 10
        ($si,$hp,$ap,$at,$in) = $line =~ /(\d+) units each with (\d+) hit points.* with an attack that does (\d+) (\w+) damage at initiative (\d+)/;
        #($si,$hp,$ap,$at,$in) = $line =~ /(\d+)/g;
        my $line2 = '';

        $line2 = $line;
        ($line2) = $line2 =~ /.*weak to ([^);]*).*/;
        my  @we  = $line2? $line2 =~ /(\w+)/g: ();

        $line2 = $line;
        ($line2) = $line2 =~ /.*immune to ([^);]*).*/;
        my  @im  = $line2? $line2 =~ /(\w+)/g: ();

        $new{si} = int($si);
        $new{hp} = int($hp);
        $new{ap} = int($ap);
        $new{at} =     $at;
        $new{in} = int($in);
        $new{we} = {}; $new{we}{$_} = '' foreach @we;
        $new{im} = {}; $new{im}{$_} = '' foreach @im;
        
        $new{ep} = int($new{si}*$new{ap});
        
        #push @$current , \%new;
        push @group , \%new;
    }

}

#print to_json \@group , {pretty=>1,canonical=>1};
#exit;

# Effective power = number of units in group times attack power

# 1. Target selection
#
# Group with highest effective power chooses first
# Tiebreakers: higher initiative
#
# Chooses the group to which it would deal most damage, including
# weakness, immunity, trample.
# Tiebreakers: largest effective power, largest initiative
# Choose no group if unable to deal damage.
# Groups can only be defenders against a single group
#
# 


# 2. Fight!
#
# Group with highest initiative goes first
# Deals damage equal to its effective power
# No damage against immune groups
# Double damage agains weak grops
# Defending group loses floor(effective power/defender hp) units


my %attacks = ();
my %defends = ();
sub pick_opponents {
    %attacks = ();
    %defends = ();
    
    foreach my $u (@group) {
        my @choice = ();
        foreach my $v (@group) {
            next if $u == $v;
            next if $u->{ty} eq $v->{ty};
            next if exists $defends{$v};
            my $immunity = exists $v->{im}->{$u->{at}};
            next if $immunity;
            my $weakness = exists $v->{we}->{$u->{at}};
            my $dam = ($immunity? 0: ($weakness? 2: 1)) * $u->{ep};
            push @choice , {dam=>$dam , pow=>$v->{ep} , init=>$v->{in} , unit=>$v};
            #printf "%s % 3d would deal %s % 3d % 8d % 12s damage, is %simmune, is %sweak (%s)\n" , $u->{ty} , $u->{id} , $v->{ty} , $v->{id} , $dam , $u->{at} , $immunity? '': 'not ' ,  $weakness? '': 'not ' , (join ' ' , keys %{$v->{we}});
        }
        if (@choice) {
            #my @tmp = %{$choice->{we}};
            @choice = sort { $b->{dam} <=> $a->{dam} or $b->{pow} <=> $a->{pow} or $b->{init} <=> $a->{init} } @choice;
            #print to_json \@choice,{pretty=>1,canonical=>1};
            my $v = $choice[0]->{unit};
            $attacks{$u} = $v;
            $defends{$v} = $u;
            #printf "%s % 3d      picks %s % 3d with % 3d initiative. Attack %s vs %s\n" , $u->{ty} , $u->{id} , $v->{ty} , $v->{id} , $v->{in} , $u->{at} , (join ' ' , keys %{$v->{im}});;
            #print to_json \%attacks,{pretty=>1,canonical=>1};
            #print to_json \%defends,{pretty=>1,canonical=>1};
            #printf "%d, %s, %s\n" , $damage , $u->{at} , $choice->{we};
        }
        else {
            #printf "%s % 3d has no-one to pick\n" , $u->{ty} , $u->{id};
        }
    }
    #print "\n";
}

my $boost = 0;
sub battle {
    my $toll_total = 0;
    foreach my $u (@group) {
        next if $u->{si} <= 0;
        next if ! defined $attacks{$u};
        my $v = $attacks{$u};
        my $immunity = exists $v->{im}->{$u->{at}};
        my $weakness = exists $v->{we}->{$u->{at}};
        my $multiplier = ($immunity? 0: ($weakness? 2: 1));
        #my $damage = $multiplier * ( $u->{ap} + ($u->{ty} eq 'immune'? $boost: 0) );
        my $damage = $multiplier * $u->{ep};
        my $toll = int( $damage / $v->{hp} );
        #printf "%s %d attacks %s %d killing %d units (attack: %s vs %s)\n" , $u->{ty} , $u->{id} , $v->{ty} , $v->{id} , min($toll,$v->{si}) , $u->{at} , (join ' ' , keys %{$v->{im}});
        $toll_total += min($toll,$v->{si});
        $v->{si} -= $toll;
        $v->{ep}  = (($v->{ty} eq 'immune'? $boost: 0) + $v->{ap}) * $v->{si};
    }
    return $toll_total;
}


my @original = @{clone(\@group)};
foreach $boost (20..100) {
#foreach $boost (0..100000) {
    @group = @{clone(\@original)};

 
    foreach my $u (@group) {
        if ($u->{ty} eq 'immune') {
            $u->{ap} += $boost;
            $u->{ep}  = $u->{si} * $u->{ap};
        }
    }
    
    #print "Immune System:\n";
    #foreach my $u (grep { $_->{ty} eq 'immune' } @group) {
    #    printf "%d units each with %d hit points (immune to %s) (weak to %s) with an attack that does %d %s damage at initiative %d and ep %d\n" ,
    #        $u->{si} , $u->{hp} , (join ' ' , keys %{$u->{im}}) , (join ' ' , keys %{$u->{we}}) , $u->{ap} , $u->{at} , $u->{in} , $u->{ep};
    #}
    #print "Infection:\n";
    #foreach my $u (grep { $_->{ty} eq 'infect' } @group) {
    #    printf "%d units each with %d hit points (immune to %s) (weak to %s) with an attack that does %d %s damage at initiative %d ep %d\n" ,
    #        $u->{si} , $u->{hp} , (join ' ' , keys %{$u->{im}}) , (join ' ' , keys %{$u->{we}}) , $u->{ap} , $u->{at} , $u->{in} , $u->{ep};
    #}
    #print "\n\n";


    
    my $round = 1;
    my $toll = 0;
    #printf "Result after round: %d:\n" , $round++;
    #print to_json \@group , {pretty=>1,canonical=>1};
    #print "\n\n";
    do {
        #printf "Round: %d:\n" , $round++;
        @group = sort { $b->{ep} <=> $a->{ep} or $b->{in} <=> $a->{in} } @group;
        
        pick_opponents();
        
        @group = sort { $b->{in} <=> $a->{in} } @group;
        $toll = battle();
        
        @group = grep { $_->{si} > 0 } @group;
        
        #printf "Result after round: %d:\n" , $round++;
        #print to_json \@group , {pretty=>1,canonical=>1};
        #print "\n\n";
        #exit;
    } while ($toll && %attacks);
    
    my $remaining = 0;
    foreach my $u (@group) {
        $remaining += $u->{si};
        printf "%s % 3d contains %d units\n" , $u->{ty} , $u->{id} , $u->{si};
    }

    print "With a boost of $boost\n";
    print "Total units remaining: $remaining\n\n";

    
    exit if all { $_->{ty} eq 'immune' } @group;
}

