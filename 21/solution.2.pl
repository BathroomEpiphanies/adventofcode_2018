use strict;
use warnings;

my ($r0,$r1,$r2,$r3,$r4,$r5) = (0,0,0,0,0,0);


$r3 = 123;
while (1) {
    $r3 = $r3 & 456;
    last if $r3 == 72;
}

$r3 = 0;
my $count = 0;
my %set = ();
while (1) {
    $r1  = $r3 | 0x00010000; #    65536; # 2^16
    $r3  =       0x00903319; #  9450265;

    while (1) {
        $r4  = $r1 & 0xFF;
        $r3 += $r4;
        $r3 &= 0x00FFFFFF; # 2^24 - 1
        $r3 *= 0x0001016B; # 65899
        $r3 &= 0x00FFFFFF; # 2^24 - 1
        
        last if 0x100 > $r1;
 
        
        $r4 = 0;
        while (1) {
            $r2  = $r4 + 1;
            $r2 *= 0x100;
            #print "$r1 $r2\n";
            last if $r2 > $r1;
            $r4++;
        }

        $r1 = $r4;
        #printf "% 32b\n" , $r1;
        #printf "% 6d\n" , $r1;

    }

    $count++;
    if ($set{$r3}) {
        printf "found repeated value for r3: %d\n" , $r3;
        printf "$count\n";
        exit;
    }
    else {
        printf "found new value for r3: %d\n" , $r3; 
        $set{$r3} = {};
    }

    
    #last if $r3 == $r0;
}
