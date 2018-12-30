use strict;
use warnings;
use List::Util qw(sum all max min);
use JSON;

my @char = split // , " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

my $i = 0;
my %grid = ();
my %step = ();
my @queue = ();
my %start = ();
foreach my $line (<STDIN>) {
    $i++;
    my ($x,$y) = $line =~ /(\d+),\s*(\d+)/;
    $grid{$x}{$y} = $i;
    $step{$x}{$y} = 0;
    push @queue , [1,$i,$x,$y];
    $start{$i}{'x'} = $x;
    $start{$i}{'y'} = $y;
}

#print to_json \@queue , {pretty => 1 , canonical => 1};
#print to_json \%grid , {pretty => 1 , canonical => 1};

my $xmin = min keys %grid;
my $xmax = max keys %grid;

my $ymin = min map {keys %{$_}} values %grid;
my $ymax = max map {keys %{$_}} values %grid;

#print "$xmin,$xmax $ymin,$ymax\n\n";

sub print_coords {
    for (my $x = $xmin; $x <= $xmax; $x++) {
        for (my $y = $ymin; $y <= $ymax; $y++) {
            if (!$grid{$x}{$y} || $grid{$x}{$y} < 0) {
                print ".";
            }
            else {
                print $char[$grid{$x}{$y}];
            }
        }
        print "\n";
    }
    print "\n";
}

print_coords();

my %infinite = ();

while (@queue) {
    my ($t,$i,$x,$y) = @{shift @queue};
    #print "$t,$i,$x,$y $grid{$x}{$y}\n";
    if($grid{$x}{$y} && $grid{$x}{$y} < 0) {
        next;
    }
    
    if ($x <= $xmin) {
        $infinite{$i} = 1;
    }
    elsif ($grid{$x-1}{$y}) {
        if ($grid{$x-1}{$y} != $i && $step{$x-1}{$y} == $t && $step{$x-1}{$y} > 0) {
            $grid{$x-1}{$y} = -1;
        }
    }
    else {
        $step{$x-1}{$y} = $t;
        $grid{$x-1}{$y} = $i;
        push @queue , [$t+1 , $i , $x-1 , $y ];
    }
    
    if ($x >= $xmax) {
        $infinite{$i} = 1;
    }
    elsif ($grid{$x+1}{$y}) {
        if($grid{$x+1}{$y} != $i && $step{$x+1}{$y} == $t && $step{$x+1}{$y} > 0) {
            $grid{$x+1}{$y} = -1;
        }
    }
    else {
        $step{$x+1}{$y} = $t;
        $grid{$x+1}{$y} = $i;
        push @queue , [$t+1 , $i , $x+1 , $y ];
    }
    
    if ($y <= $ymin) {
        $infinite{$i} = 1;
    }
    elsif ($grid{$x}{$y-1}) {
        if($grid{$x}{$y-1} != $i && $step{$x}{$y-1} == $t && $step{$x}{$y-1} > 0) {
            $grid{$x}{$y-1} = -1;
        }
    }
    else {
        $step{$x}{$y-1} = $t;
        $grid{$x}{$y-1} = $i;
        push @queue , [$t+1 , $i , $x , $y-1 ];
    }
    
    if ($y >= $ymax) {
        $infinite{$i} = 1;
    }
    elsif ($grid{$x}{$y+1}) {
        if($grid{$x}{$y+1} != $i && $step{$x}{$y+1} == $t && $step{$x}{$y+1} > 0) {
            $grid{$x}{$y+1} = -1;
        }
    }
    else {
        $step{$x}{$y+1} = $t;
        $grid{$x}{$y+1} = $i;
        push @queue , [$t+1 , $i , $x , $y+1 ];
    }
    
}


print_coords();

for (my $x = $xmin; $x <= $xmax; $x++) {
    for (my $y = $ymin; $y <= $ymax; $y++) {
        if ($grid{$x}{$y} && $infinite{$grid{$x}{$y}}) {
            $grid{$x}{$y} = -1;
        }
    }
}

#print "\n";

print_coords();

my %area = ();
foreach $i (keys %start) {
    $area{$i} = scalar(grep { $_ == $i } map { values %{$_} } values %grid);
}

print to_json \%area , {pretty => 1 , canonical => 1};

print max values %area;
print "\n";
#my $highest = max_by { $area{$_} } keys %area;

#print to_json \%start , {pretty => 1 , canonical => 1};

#exit;
my $count = 0;
for (my $x = $xmin; $x <= $xmax; $x++) {
    for (my $y = $ymin; $y <= $ymax; $y++) {
        my $sum = 0;
        foreach $i (keys %start) {
            $sum += abs($x-$start{$i}{'x'}) + abs($y-$start{$i}{'y'});
        }
        if ($sum < 10000) {
            $count++;
        }
    }
}
            
print "$count\n";
