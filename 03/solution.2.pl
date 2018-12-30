use strict;
use warnings;
use List::Util qw(sum any);
use JSON;

my %claim = ();
my %fabric = ();
foreach my $line (<STDIN>) {
    my ($id,$x,$y,$dx,$dy) = $line =~ /#(\d+)\s+@\s+(\d+),(\d+):\s+(\d+)x(\d+)/;
    #printf "%d %d %d %d %d\n", $id,$x,$y,$dx,$dy;

    $claim{$id} = [$x,$y,$dx,$dy];

    for (my $i = $x; $i < $x+$dx; $i++) {
        for (my $j = $y; $j < $y+$dy; $j++) {
            $fabric{$i}{$j} ++;
        }
    }
    
    #    foreach my $i ($x..$x+$dx-1) {
    #        #map { $fabric{$i}{$_}++ } ($y..$y+$dy-1);
    #        print map { $_++ } map { $_{} } ($x..$x+$dx-1) map { \$fabric{$_} } ($y..$y+$dy-1);
    #        print "\n";
    #    }
}

#print to_json \%claim, {pretty => 1, canonical => 1};
#print to_json \%fabric, {pretty => 1, canonical => 1};

# Find square inches with overlap of 2 or more
my $overlap = grep { $_ > 1 } map { values %{$_} } values %fabric;
print "Square inches with overlap: $overlap\n";

#@unique = grep { $_ }


while (my ($id,$data) = (each %claim)) {
    my $test = 1;
    my ($x,$y,$dx,$dy) = @{$data};
    map { map { $fabric{$_} } ($x..$x+$dx-1);
    print grep { $x <= $_ && $_ < $x+$dx } keys %fabric;
    print "\n";
}

exit;

while (my ($id,$data) = (each %claim)) {
    my $test = 1;
    my ($x,$y,$dx,$dy) = @{$data};
    #printf "%d %d %d %d\n", $x,$y,$dx,$dy;
    for (my $i = $x; $i < $x+$dx; $i++) {
        for (my $j = $y; $j < $y+$dy; $j++) {
            $test &= $fabric{$i}{$j} < 2;
        }
    }
    if($test) {
        print "$id\n";
    }
}
