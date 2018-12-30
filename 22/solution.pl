use strict;
use warnings;
use List::Util qw(sum);


my $line = <STDIN>;
chomp $line;
my ($depth) = ($line =~ /(\d+)/);
$line = <STDIN>;
chomp $line;
my ($xt,$yt) = ($line =~ /(\d+)/g);


my ($xmax,$ymax) = ($xt+5,$yt+5);
my @cave = ();
my @erosion = ();
$erosion[0][0] = $depth % 20183;
for (my $y = 1; $y <= $ymax; $y++) {
    $erosion[$y][0] = ($y*48271 + $depth) % 20183;
}
for (my $x = 1; $x <= $xmax; $x++) {
    $erosion[0][$x] = ($x*16807 + $depth) % 20183;
}

for (my $y = 1; $y <= $ymax; $y++) {
    for (my $x = 1; $x <= $xmax; $x++) {
        if ($y == $yt && $x == $xt) {
            $erosion[$y][$x] = $depth % 20183;
        }
        else {
            $erosion[$y][$x] = ($erosion[$y-1][$x]*$erosion[$y][$x-1] + $depth) % 20183;
        }
    }
}

for (my $y = 0; $y <= $ymax; $y++) {
    for (my $x = 0; $x <= $xmax; $x++) {
        $cave[$y][$x] = $erosion[$y][$x] % 3;
    }
}

sub print_cave {
    for (my $y = 0; $y <= $ymax; $y++) {
        for (my $x = 0; $x <= $xmax; $x++) {
            #printf "% 8d" , $erosion[$y][$x];
            printf "%s" , $cave[$y][$x]==0? '.': ($cave[$y][$x]==1? '=': '|');
        }
        print "\n";
    }
    print "\n";
}


print_cave();


#my @risk = map { sum @{$_}[0..$xt] } @cave[0..$yt];
#print "risk @risk\n";

my $risk = sum map { sum @{$_}[0..$xt] } @cave[0..$yt];
print "risk $risk\n";
