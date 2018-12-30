use strict;
use warnings;
use JSON;


sub read_cave {
    my @cave = ();
    my @goblin = ();
    my @elf = ();
    my $y = 0;
    while (my $line = <STDIN>) {
        chomp($line);
        last if length($line) == 0;
        my @list = split // , $line;

        foreach my $i (0..$#list) {
            if ($list[$i] eq 'G') {
                push @goblin , {x=>$i,y=>$y,h=>200,r=>'G'};
            }
            elsif ($list[$i] eq 'E') {
                push @elf , {x=>$i,y=>$y,h=>200,r=>'E'};
            }
        }
        #$line =~ m/(G)/g;
        #print to_json \@-;
        #print "\n";
        #print to_json \@+;
        #print "\n";
        #print "\n";
        #foreach (1..$#-) {
        #    push @goblin , {x=>$-[$_],y=>$y,h=>200,r=>'G'};
        #}
        ##push @goblin , {x=>$-[$_],y=>$y,h=>200,r=>'G'} foreach 1..$#-;
        #$line =~ m/(E)/g;
        ##push @elf , {x=>$-[$_],y=>$y,h=>200,r=>'E'} foreach 1..$#-;
        
        push @cave , [split // , $line];
        $y++;
    }
    return \@cave,\@goblin,\@elf;
}

sub print_cave {
    my @cave = @_;
    printf "%s\n" , join '' , @{$cave[$_]} foreach 0..$#cave;
}

sub hit {

    return 0;
}

sub find_enemy {
    my ($np,$cp) = @_;
    my %n = %$np;
    my @cave = @{$cp};

    print_cave(@cave);
    print to_json \%n , {pretty=>1};
    return if hit();
    my @q = ();
    my @dist = ();
    $dist[$n{y}][$n{x}] = 0;
    push @q , [$n{x},$n{y}];
    print to_json \@q , {pretty=>1};
    while (@q) {
        my ($x,$y) = @{shift @q};
        my $d = $dist[$y][$x];
        #printf "x %d y %d d %d\n" , $x , $y , $d;
        if ( (! $dist[$y-1][$x] || $dist[$y-1][$x] > $d) && $cave[$y-1][$x] eq '.') {
            push @q , [$x,$y-1];
            $dist[$y-1][$x] = $d+1;
        }
        if ( (! $dist[$y][$x-1] || $dist[$y][$x-1] > $d) && $cave[$y][$x-1] eq '.') {
            push @q , [$x-1,$y];
            $dist[$y][$x-1] = $d+1;
        }
        if ( (! $dist[$y][$x+1] || $dist[$y][$x+1] > $d) && $cave[$y][$x+1] eq '.') {
            push @q , [$x+1,$y];
            $dist[$y][$x+1] = $d+1;
        }
        if ( (! $dist[$y+1][$x] || $dist[$y+1][$x] > $d) && $cave[$y+1][$x] eq '.') {
            push @q , [$x,$y+1];
            $dist[$y+1][$x] = $d+1;
        }
    }

    print to_json \@dist , {pretty=>1};
    

    foreach my $y (1..$#dist) {
        my @list = @{$dist[$y]};
        foreach my $x (0..$#list) {
            if($dist[$y][$x]) {
                printf "%2d " , $dist[$y][$x];
            }
            else {
                printf "% 2s " , $cave[$y][$x];
            }
        }
        print"\n";
    }
    #printf "%s\n" , join '' , @{$_} foreach @dist;
    
}

sub find {
    my @dirs = [[0,-1],[-1,0],[+1,0],[0,+1]];
    return -1;
}

sub move {
    my @dist = ();
    #print to_json \%{$_};
    
    #printf "%s\n" , $_[0]->{r};
    #printf "%s %s %s\n" , $_->{r} , $_->{x} , $_->{y};
}




my ($cp,$gp,$ep) = read_cave();
my @cave = @$cp;
my @goblin = @$gp;
my @elf = @$ep;
push @goblin , @elf;
my @nisse = @goblin;
@nisse = sort {$a->{y} <=> $b->{y} or $a->{x} <=> $b->{x}} @nisse;


foreach my $n (@nisse) {
    find_enemy($n,\@cave);
    #move($n);
}

print to_json \@nisse , {pretty=>1};

print_cave(@cave);
