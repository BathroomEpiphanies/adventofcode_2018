use strict;
use warnings;
use List::Util qw(sum any min max);
use JSON;
use Term::ReadKey;


my %position = ();
my %velocity = ();
my $i = 1;
foreach my $line (<STDIN>) {
    chomp($line);
    my ($px,$py,$vx,$vy) = $line =~ /position=<\s*(-?\d+),\s*(-?\d+)>\s*velocity=<\s*(-?\d+),\s*(-?\d+)>/;

    #$position{$i} = ('x',$px,'y',$py);
    #$velocity{$i} = ('x',$vx,'y',$vy);
    
    $position{$i}{'x'} = $px;
    $velocity{$i}{'x'} = $vx;
    $position{$i}{'y'} = $py;
    $velocity{$i}{'y'} = $vy;
    print "$px,$py,$vx,$vy\n";

    $i++;
}

print to_json \%position , {pretty=>1,canonical=>1};

sub message {
    my $xmin = min map { $position{$_}{'x'} } keys %position;
    my $xmax = max map { $position{$_}{'x'} } keys %position;
    my $ymin = min map { $position{$_}{'y'} } keys %position;
    my $ymax = max map { $position{$_}{'y'} } keys %position;

    my %field = ();
    foreach my $k (keys %position) {
        $field{$position{$k}{'x'}}{$position{$k}{'y'}} = {};
    }
    
    for (my $y = $ymin; $y <= $ymax; $y++) {
        print "|";
        for (my $x = $xmin; $x <= $xmax; $x++) {
            if(! $field{$x}{$y}) {
                print " ";
            }
            else {
                print "#";
            }
        }
        print "|\n";
    }
    print "\n";

    return ($xmax-$xmin)*($ymax-$ymin);
}

sub move {
    foreach my $k (keys %position) {
        $position{$k}{'x'} += $velocity{$k}{'x'};
        $position{$k}{'y'} += $velocity{$k}{'y'};
    }
}

sub move_back {
    foreach my $k (keys %position) {
        $position{$k}{'x'} -= $velocity{$k}{'x'};
        $position{$k}{'y'} -= $velocity{$k}{'y'};
    }
}


sub area {
    my $xmin = min map { $position{$_}{'x'} } keys %position;
    my $xmax = max map { $position{$_}{'x'} } keys %position;
    my $ymin = min map { $position{$_}{'y'} } keys %position;
    my $ymax = max map { $position{$_}{'y'} } keys %position;
    return ($xmax-$xmin)*($ymax-$ymin);
}

my $area = area();
my $prev = $area + 1;
my $t = 0;
while ($area < $prev) {
    $t++;
    move();
    $prev = $area;
    $area = area();
}

move_back();
$t--;
message();
print "after $t seconds \n";
