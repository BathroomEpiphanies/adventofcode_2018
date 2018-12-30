use List::Util sum,any;
use JSON;

foreach $line (<STDIN>) {
    my ($id,$x,$y,$dx,$dy) = $line =~ /#(\d+)\s+@\s+(\d+),(\d+):\s+(\d+)x(\d+)/;
    #printf "%d %d %d %d %d\n", $id,$x,$y,$dx,$dy;

    $claim{$id} = [$x,$y,$dx,$dy];
    
    for ($i = $x; $i < $x+$dx; $i++) {
        for ($j = $y; $j < $y+$dy; $j++) {
            $fabric{$i}{$j} ++;
        }
    }
}

#print to_json \%claim, {pretty => 1, canonical => 1};
#print to_json \%fabric, {pretty => 1, canonical => 1};

foreach $outer (values %fabric) {
    foreach $inner (values %{$outer}) {
        if ($inner > 1) {
            $count++;
        }
    }
}

print "$count\n";

while (($id,$data) = (each %claim)) {
    $test = 1;
    ($x,$y,$dx,$dy) = @{$data};
    #printf "%d %d %d %d\n", $x,$y,$dx,$dy;
    for ($i = $x; $i < $x+$dx; $i++) {
        for ($j = $y; $j < $y+$dy; $j++) {
            $test &= $fabric{$i}{$j} < 2;
        }
    }
    if($test) {
        print "$id\n";
    }
}
