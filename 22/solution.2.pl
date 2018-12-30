use strict;
use warnings;
use List::Util qw(sum);
use JSON;


my $line = <STDIN>;
chomp $line;
my ($depth) = ($line =~ /(\d+)/);
$line = <STDIN>;
chomp $line;
my ($xt,$yt) = ($line =~ /(\d+)/g);


my ($xmax,$ymax) = ($xt+5,$yt+5);
my @cave = ();
my @risk = ();
my @erosion = ();


$erosion[0][0]     = $depth % 20183;
$erosion[$yt][$xt] = $depth % 20183;
sub erosion {
    my ($x,$y) = @_;
    if ( ! defined $erosion[$y][$x] ) {
        if    ($y==0) { $erosion[$y][$x] = ($x*16807 + $depth) % 20183; }
        elsif ($x==0) { $erosion[$y][$x] = ($y*48271 + $depth) % 20183; }
        else          { $erosion[$y][$x] = (erosion($x,$y-1) * erosion($x-1,$y) + $depth) % 20183; }
    }
    return $erosion[$y][$x];
}
#printf "%s\n" , cave(2,5);
sub cave {
    my ($x,$y) = @_;
    if ( ! defined $cave[$y][$x] ) {
        $risk[$y][$x] = erosion($x,$y) % 3;
        $cave[$y][$x] = $risk[$y][$x]==0? '.': ($risk[$y][$x]==1? '=': '|');
    }
    return $cave[$y][$x];
}


sub print_cave {
    for (my $y = 0; $y <= $ymax; $y++) {
        for (my $x = 0; $x <= $xmax; $x++) {
            printf "%s" , cave($x,$y);
        }
        print "\n";
    }
    print "\n";
}


print_cave();

#my @risk = map { sum @{$_}[0..$xt] } @cave[0..$yt];
#print "risk @risk\n";

my $risk_sum = sum map { sum @{$_}[0..$xt] } @risk[0..$yt];
print "Total risk $risk_sum\n";



# List element {x=>xpos, y=>ypos, e=>equipment, d=>dist}
# equipment ' '-none, 't'-torch, 'c'-climbing
#my $queue = new List::PriorityQueue;
my @queue;
my @dist = ();
push @queue , {x=>0,y=>0,e=>'t',d=>0};
$dist[0][0]{'t'} = $queue[0];
    
#print to_json \@queue , {pretty=>1,canonical=>1};
#print to_json \@dist , {pretty=>1,canonical=>1};

#exit;
while (@queue) {
    @queue = sort { $a->{d} <=> $b->{d} } @queue;
    #my $q =  pop @queue;
    #my ($x,$y,$e,$d) = %{shift @queue};
    my $q = shift @queue;
    #print to_json $q , {pretty=>1,canonical=>1};
    if ($q->{x} == $xt && $q->{y} == $yt && $q->{e} eq 't') {
        printf "Found target at: %d,%d with equipment: %s after: %d minutes\n" , $q->{x}, $q->{y}, $q->{e}, $q->{d};
        exit;
    }
    foreach my $f (' ','t','c') {
        next if
            $f eq $q->{e} ||
            cave($q->{x},$q->{y}) eq '.' && $f eq ' ' || 
            cave($q->{x},$q->{y}) eq '=' && $f eq 't' ||
            cave($q->{x},$q->{y}) eq '|' && $f eq 'c';
        if ( ! defined $dist[$q->{y}][$q->{x}]{$f} ) {
            push @queue , {x=>$q->{x},y=>$q->{y},e=>$f,d=>$q->{d}+7};
            $dist[$q->{y}][$q->{x}]{$f} = $queue[$#queue];
        }
        elsif ( $dist[$q->{y}][$q->{x}]{$f}->{d} > $q->{d} + 7 ) {
            $dist[$q->{y}][$q->{x}]{$f}->{d} = $q->{d} + 7;
        }
    }
    foreach my $o ({x=>0,y=>-1},{x=>0,y=>1},{x=>-1,y=>0},{x=>1,y=>0}) {
        next if 
            $q->{x}+$o->{x} < 0 || 
            $q->{y}+$o->{y} < 0 ||
            cave($q->{x}+$o->{x},$q->{y}+$o->{y}) eq '.' && $q->{e} eq ' ' ||
            cave($q->{x}+$o->{x},$q->{y}+$o->{y}) eq '=' && $q->{e} eq 't' ||
            cave($q->{x}+$o->{x},$q->{y}+$o->{y}) eq '|' && $q->{e} eq 'c';
        if ( ! defined $dist[$q->{y}+$o->{y}][$q->{x}+$o->{x}]{$q->{e}} ) {
            push @queue , {x=>$q->{x}+$o->{x},y=>$q->{y}+$o->{y},e=>$q->{e},d=>$q->{d}+1};
            $dist[$q->{y}+$o->{y}][$q->{x}+$o->{x}]{$q->{e}} = $queue[$#queue];
        }
        elsif ( $dist[$q->{y}+$o->{y}][$q->{x}+$o->{x}]{$q->{e}}->{d} > $q->{d} + 1 ) {
            $dist[$q->{y}+$o->{y}][$q->{x}+$o->{x}]{$q->{e}}->{d} = $q->{d} + 1;
        }
    }
}


