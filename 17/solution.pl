use strict;
#use warnings;


my @ground = ();
my ($xmin, $xmax, $ymin, $ymax);
    
sub read_ground {
    foreach my $line (<STDIN>) {
        chomp($line);
        my ($o1,$a1,$o2,$b1,$b2) = $line =~ /(x|y)=(-?\d+), (x|y)=(-?\d+)\.\.(-?\d+)/;

        if ($o1 eq 'x') {
            $ymin = $b1 if ( ! defined $ymin || $ymin > $b1);
            $ymax = $b2 if ( ! defined $ymax || $ymax < $b2);
            $xmin = $a1 if ( ! defined $xmin || $xmin > $a1);
            $xmax = $a1 if ( ! defined $xmax || $xmax < $a1);
            for (my $i = $b1; $i <= $b2; $i++) {
                $ground[$i][$a1] = '#';
            }
        }
        else {
            $xmin = $b1 if ( ! defined $xmin || $xmin > $b1);
            $xmax = $b2 if ( ! defined $xmax || $xmax < $b2);
            $ymin = $a1 if ( ! defined $ymin || $ymin > $a1);
            $ymax = $a1 if ( ! defined $ymax || $ymax < $a1);
            for (my $i = $b1; $i <= $b2; $i++) {
                $ground[$a1][$i] = '#';
            }
        }
    }
    $ground[0][500] = '+';
    #$ymin = 0;
    $xmin--;
    $xmax++;
}


sub print_ground {
    my $water = 0;
    for (my $y = $ymin; $y <= $ymax; $y++) {
        for (my $x = $xmin; $x <= $xmax; $x++) {
            printf "%s" , $ground[$y][$x]? $ground[$y][$x]: '.';
	    $water++ if $ground[$y][$x] && $ground[$y][$x] =~ /[~]/; 
        }
        print "\n";
    }
    return $water;
}


read_ground();
#print_ground(); print "\n";

my @dir = [{x=>0,y=>1},{x=>1,y=>0},{x=>-1,y=>0}];

sub fill_down {
    my ($x,$y) = @_;
    return 0 if $y > $ymax;
    return 0 if $ground[$y][$x] && $ground[$y][$x] =~ /\|/;
    return 1 if $ground[$y][$x] && $ground[$y][$x] =~ /[#~]/;
    $ground[$y][$x] = '|';
    #print_ground();
    my $test1 = fill_down($x,$y+1);
    my $test2 = $test1 && fill_left($x-1,$y);
    my $test3 = $test1 && fill_right($x+1,$y);
    my $test = $test1 && $test2 && $test3;
    if ($test) {
	$ground[$y][$x] = '~';
	for (my $i=$x; $ground[$y][$i] ne '#'; $i++) {
	    $ground[$y][$i] = '~';
	}
	for (my $i=$x; $ground[$y][$i] ne '#'; $i--) {
	    $ground[$y][$i] = '~';
	}
    }
    #print_ground();
    return $test;
}

sub fill_left {
    my ($x,$y) = @_;
    return 0 if $x < $xmin;
    return 1 if $ground[$y][$x] && $ground[$y][$x] eq '#';
    $ground[$y][$x] = '|';
    #print_ground();
    return 1 if fill_down($x,$y+1) && fill_left($x-1,$y);
    return 0;
}

sub fill_right {
    my ($x,$y) = @_;
    return 0 if $x > $xmax;
    return 1 if $ground[$y][$x] && $ground[$y][$x] eq '#';
    $ground[$y][$x] = '|';
    #print_ground();
    return 1 if fill_down($x,$y+1) && fill_right($x+1,$y);
    return 0;
}


fill_down(500,1);
printf "water fills %d squares\n" , print_ground();

