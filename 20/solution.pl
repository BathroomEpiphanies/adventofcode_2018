use strict;
use warnings;
use Time::HiRes qw(usleep);

my @expr = split // , <STDIN>;

print "@expr\n";

my @map = ();
my ($x0,$y0) = (10000,10000);
my ($x,$y) = ($x0,$y0);
my ($xmin,$xmax,$ymin,$ymax) = ($x,$y,$x,$y);
$map[$y][$x] = '^';

sub print_map {
    for my $j ($ymin-1..$ymax+1) {
        for my $i ($xmin-1..$xmax+1) {
            printf "%s" , $j==$y&&$i==$x? '$': ($map[$j][$i]? $map[$j][$i]: '#');
        }
        printf "\n";
    }
    printf "\n";
}



my @stack = ();
push @stack , ($x,$y);
foreach my $i (1..$#expr-1) {
    print "$i $expr[$i]\n";
    if    ($expr[$i] =~ /[\^(]/) {
        push @stack , ($x,$y);
        next;
    }
    elsif ($expr[$i] =~ /[)\$]/) {
        ($x,$y) = splice @stack , $#stack-1;
        next;
    }
    elsif ($expr[$i] eq '|') {
        $x = $stack[$#stack-1];
        $y = $stack[$#stack];
        
        #($x,$y) = $stack[$#stack-1,$#stack];
    }
    elsif ($expr[$i] eq 'N') {
        $map[--$y][$x] = '-';
        $map[--$y][$x] = '.';
        $ymin = $y if $y < $ymin;
    }
    elsif ($expr[$i] eq 'S') {
        $map[++$y][$x] = '-';
        $map[++$y][$x] = '.';
        $ymax = $y if $y > $ymax;
    }
    elsif ($expr[$i] eq 'W') {
        $map[$y][--$x] = '|';
        $map[$y][--$x] = '.';
        $xmin = $x if $x < $xmin;
    }
    elsif ($expr[$i] eq 'E') {
        $map[$y][++$x] = '|';
        $map[$y][++$x] = '.';
        $xmax = $x if $x > $xmax;
    }
    #print_map();
    #usleep(100000);
}

print_map();

my @dist = ();
my @queue = ();
my $dmax = 0;
my $dcount = 0;
push @queue , ($x0,$y0,0);
while (@queue) {
    my ($x,$y,$d) = splice @queue , 0 , 3;
    $dmax = $d;
    $dcount++ if $d >= 2000 && $map[$y][$x] eq '.';
    foreach my $o ([0,-1],[0,1],[-1,0],[1,0]) {
        if ( $map[$y+$o->[1]][$x+$o->[0]] && 
             ($map[$y+$o->[1]][$x+$o->[0]] =~ /[.|-]/) && 
             (! $dist[$y+$o->[1]][$x+$o->[0]]) ) {
            $dist[$y+$o->[1]][$x+$o->[0]] = $d+1;
            push @queue , ($x+$o->[0], $y+$o->[1], $d+1);
        }
    }
}

printf "max distance: %f\n" , 0.5*$dmax;
printf "distant rooms: %f\n" , $dcount;

my $count = map { grep $_ >= 2000 } (@dist);
printf "distant rooms: %f\n" , $count;
