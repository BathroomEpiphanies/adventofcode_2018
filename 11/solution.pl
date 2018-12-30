use strict;
use warnings;


sub val {
    my ($serial,$x,$y) = @_;
    my $id = $x + 10;
    my $level = $id * $y;
    $level += $serial;
    $level *= $id;
    $level = int($level/100) % 10;
    $level -= 5;
    #print "$serial,$x,$y,$level\n";
    return $level;
}

my %grid = ();

foreach my $serial (<STDIN>) {
    chomp($serial);


    for (my $i = 0; $i <= 300; $i++) {
        $grid{$i}{0} = 0;
        $grid{0}{$i} = 0;
    }
    for (my $x = 1; $x <= 300; $x++) {
        for (my $y = 1; $y <= 300; $y++) {
            #$grid{$x}{$y} = val($serial,$x,$y) + ${$grid{$x}}{$y-1} + ${$grid{$x-1}}{$y} - ${$grid{$x-1}}{$y-1};
            $grid{$x}{$y} = val($serial,$x,$y) + $grid{$x}{$y-1} + $grid{$x-1}{$y} - $grid{$x-1}{$y-1};
        }
    }
    
    #for (my $x = 290; $x <= 300; $x++) {
    #    for (my $y = 290; $y <= 300; $y++) {
    #        printf "%8d" , val($serial,$y,$x);
    #    }
    #    print "\n";
    #}
    #print "\n";
    #
    #for (my $x = 290; $x <= 300; $x++) {
    #    for (my $y = 290; $y <= 300; $y++) {
    #        printf "%8d" , $grid{$y}{$x};
    #    }
    #    print "\n";
    #}
    #print "\n";


    my $size = 0;
    my $xpos = 0;
    my $ypos = 0;
    my $max = -999999999;
    
    
    #for (my $s = 1; $s<=300; $s++) {
    for (my $s = 3; $s<=30; $s++) {
        #print "size $s\n";
        for (my $x = 1; $x <= 300-$s; $x++) {
            for (my $y = 1; $y <= 300-$s; $y++) {
                #my $sum = ${$grid{$x+$s-1}}{$y+$s-1} - ${$grid{$x-1}}{$y+$s-1} - ${$grid{$x+$s-1}}{$y-1} + ${$grid{$x-1}}{$y-1};
                my $sum = $grid{$x+$s-1}{$y+$s-1} - $grid{$x-1}{$y+$s-1} - $grid{$x+$s-1}{$y-1} + $grid{$x-1}{$y-1};
                if ( $sum > $max ) {
                    $size = $s;
                    $xpos = $x;
                    $ypos = $y;
                    $max = $sum;
                }
            }
        }
    }

    
    
    print "max is $max in square of at position and size $xpos,$ypos,$size\n";
    #print "max is $max at $xpos,$ypos\n";
}
