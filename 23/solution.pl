use strict;
use warnings;
use JSON;

my @bots = ();
foreach my $line (<STDIN>) {
    my ($x,$y,$z,$r) = $line =~ /(-?\d+)/g;
    print "$x,$y,$z,$r\n";
    push @bots , {x=>$x,y=>$y,z=>$z,r=>$r};
}
exit;
@bots = sort { $a->{r} <=> $b->{r} } @bots;

#print to_json \@bots , {pretty=>1,canonical=>1};


my $a = $bots[$#bots];
print to_json $a , {pretty=>1,canonical=>1};

my $count = 0;
foreach my $b (@bots) {
    my $d = abs($b->{x}-$a->{x}) + abs($b->{y}-$a->{y}) + abs($b->{z}-$a->{z});
    printf "The nanobot at %d,%d,%d is distance %d away, and so it is%s in range.\n" , $b->{x} , $b->{y} , $b->{z} , $d , $d <= $a->{r}? '': ' not';
    $count++ if $d <= $a->{r};
}

print "max: $count\n";


sub bot_count {
    my $a = $_[0];
    #print to_json $a , {pretty=>1,canonical=>1};
    my $count = 0;
    foreach my $b (@bots) {
        my $d = abs($b->{x}-$a->{x}) + abs($b->{y}-$a->{y}) + abs($b->{z}-$a->{z});
        $count++ if $d <= $b->{r};
    }
    return $count;
}

#printf "%d\n" , bot_count({x=>0,y=>0,z=>0});
#exit;

my @pos = ();
my $max_count = 0;
for (my $d=0; ; $d++) {
    print "distance: $d^3\n";
    foreach my $x (int(-$d),int($d)) {
        for (my $y = -$d; $y <= $d; $y++) {
            for (my $z = -$d; $z <= $d; $z++) {
                $count = bot_count({x=>$x,y=>$y,z=>$z});
                if ($count > $max_count) {
                    $max_count = $count;
                    my $d = abs($x) + abs($y) + abs($z);
                    push @pos , [$x,$y,$z,$count,$d];
                    print to_json $pos[$#pos] , {pretty=>1,canonical=>1};
                    print "\n";
                }
            }
        }
    }
    
    foreach my $y (int(-$d),int($d)) {
        for (my $x = -$d; $x <= $d; $x++) {
            for (my $z = -$d; $z <= $d; $z++) {
                $count = bot_count({x=>$x,y=>$y,z=>$z});
                if ($count > $max_count) {
                    $max_count = $count;
                    push @pos , [$x,$y,$z,$count];
                    print to_json $pos[$#pos] , {pretty=>1,canonical=>1};
                    print "\n";
                }
            }
        }
    }

    foreach my $z (int(-$d),int($d)) {
        for (my $x = -$d; $x <= $d; $x++) {
            for (my $y = -$d; $y <= $d; $y++) {
                $count = bot_count({x=>$x,y=>$y,z=>$z});
                if ($count > $max_count) {
                    $max_count = $count;
                    push @pos , [$x,$y,$z,$count];
                    print to_json $pos[$#pos] , {pretty=>1,canonical=>1};
                    print "\n";
                }
            }
        }
    }
}
