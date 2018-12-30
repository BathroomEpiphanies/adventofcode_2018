use strict;
use warnings;
use JSON;
use List::Util qw(min max);

$| = 1;

my @bots = ();
foreach my $line (<STDIN>) {
    my ($x,$y,$z,$r) = $line =~ /(-?\d+)/g;
    #print "$x,$y,$z,$r\n";
    #push @bots , {x=>$x,y=>$y,z=>$z,r=>$r};
    push @bots , {x=>$x+200000000,y=>$y+200000000,z=>$z+200000000,r=>$r};
}

@bots = sort { $a->{r} <=> $b->{r} } @bots;
foreach my $i (0..$#bots) {
    $bots[$i]->{i} = int $i;
}

printf "number of bots: %d\n\n" , scalar @bots;



my $xmin = min map { $_->{x} } @bots;
my $xmax = max map { $_->{x} } @bots;
my $ymin = min map { $_->{y} } @bots;
my $ymax = max map { $_->{y} } @bots;
my $zmin = min map { $_->{z} } @bots;
my $zmax = max map { $_->{z} } @bots;

printf "ranges x:%d,%d\n" , $xmin , $xmax;
printf "ranges y:%d,%d\n" , $ymin , $ymax;
printf "ranges z:%d,%d\n" , $zmin , $zmax;


sub reach_box {
    my ($xl,$yl,$zl,$xu,$yu,$zu) = @_;
    my $count = 0;
    foreach my $b (@bots) {
        my $d = 0;
        $d += $xl - $b->{x} if $b->{x} < $xl;
        $d += $b->{x} - $xu if $b->{x} > $xu;
        $d += $yl - $b->{y} if $b->{y} < $yl;
        $d += $b->{y} - $yu if $b->{y} > $yu;
        $d += $zl - $b->{z} if $b->{z} < $zl;
        $d += $b->{z} - $zu if $b->{z} > $zu;

        $count++ if $d <= $b->{r};
        
        #print "$b->{x} $b->{y} $b->{z} $b->{r}\n";
        #if (  $b->{y} >= $yl && $b->{y} <= $yu && $b->{z} >= $zl && $b->{z} <= $zu &&   $b->{x}-$b->{r} <= $xu && $b->{x}+$b->{r} >= $xl  ||
        #      $b->{x} >= $xl && $b->{x} <= $xu && $b->{z} >= $zl && $b->{z} <= $zu &&   $b->{y}-$b->{r} <= $yu && $b->{y}+$b->{r} >= $yl  ||
        #      $b->{x} >= $xl && $b->{x} <= $xu && $b->{y} >= $yl && $b->{y} <= $yu &&   $b->{z}-$b->{r} <= $zu && $b->{z}+$b->{r} >= $zl  ) {
        #    $count++;
        #}
    }
    return $count;
}


#my $test = reach_box(-200000000,-200000000,-200000000,200000000,200000000,200000000);
my $test = reach_box(0,0,0,400000000,400000000,400000000);
print "$test\n";

my $min_dist = 400000000;
my $max_bot = 980;
sub find_max {
    my ($xl,$yl,$zl,$xu,$yu,$zu) = @_;
    #printf "% 8d,% 8d,% 8d   % 8d,% 8d,% 8d\n" , $xl,$yl,$zl,$xu,$yu,$zu;
    #printf "(% 13.2f,% 13.2f,% 13.2f)  (% 13.2f,% 13.2f,% 13.2f)  (% 13.2f,% 13.2f,% 13.2f)\n" , $xl,$yl,$zl , $xu,$yu,$zu , $xu-$xl,$yu-$yl,$zu-$zl;
    if ( $xu < $xl || $yu < $yl || $zu < $zl ) {
        return 0;
    }
    if ( $xu == $xl && $yu == $yl && $zu == $zl ) {
        my $sum = reach_box($xl,$yl,$zl,$xu,$yu,$zu);
        my $dist = abs($xl-200000000) + abs($yl-200000000) + abs($zl-200000000);
        if ($sum > $max_bot) {
            print "$xl,$yl,$zl $sum $dist\n";
            $max_bot = $sum;
            $min_dist = $dist;
        }
        elsif ($sum == $max_bot && $dist < $min_dist) {
            print "$xl,$yl,$zl $sum $dist\n";
            $min_dist = $dist;
        }
        return $sum;
    }
    
    my $box1 = reach_box(                $xl,                $yl,                $zl       ,    int(($xl+$xu)/2), int(($yl+$yu)/2), int(($zl+$zu)/2) );
    my $box2 = reach_box( int(($xl+$xu)/2)+1,                $yl,                $zl       ,                 $xu, int(($yl+$yu)/2), int(($zl+$zu)/2) );
    my $box3 = reach_box(                $xl, int(($yl+$yu)/2)+1,                $zl       ,    int(($xl+$xu)/2),              $yu, int(($zl+$zu)/2) );
    my $box5 = reach_box(                $xl,                $yl, int(($zl+$zu)/2)+1       ,    int(($xl+$xu)/2), int(($yl+$yu)/2),              $zu );
    my $box4 = reach_box( int(($xl+$xu)/2)+1, int(($yl+$yu)/2)+1,                $zl       ,                 $xu,              $yu, int(($zl+$zu)/2) );
    my $box6 = reach_box( int(($xl+$xu)/2)+1,                $yl, int(($zl+$zu)/2)+1       ,                 $xu, int(($yl+$yu)/2),              $zu );
    my $box7 = reach_box(                $xl, int(($yl+$yu)/2)+1, int(($zl+$zu)/2)+1       ,    int(($xl+$xu)/2),              $yu,              $zu );
    my $box8 = reach_box( int(($xl+$xu)/2)+1, int(($yl+$yu)/2)+1, int(($zl+$zu)/2)+1       ,                 $xu,              $yu,              $zu );

    #printf "% 4d % 4d\n" , $box3 , $box4;
    #printf "% 4d % 4d\n" , $box1 , $box2;
    #printf "\n";
    #printf "% 4d % 4d\n" , $box7 , $box8;
    #printf "% 4d % 4d\n" , $box5 , $box6;
    #printf "\n\n";

    #my $max = max ($box1,$box2,$box3,$box4,$box5,$box6,$box7,$box8);
    #if ($box1 == $max) { find_max(                $xl,                $yl,                $zl       ,    int(($xl+$xu)/2), int(($yl+$yu)/2), int(($zl+$zu)/2) ); }
    #if ($box2 == $max) { find_max( int(($xl+$xu)/2)+1,                $yl,                $zl       ,                 $xu, int(($yl+$yu)/2), int(($zl+$zu)/2) ); }
    #if ($box3 == $max) { find_max(                $xl, int(($yl+$yu)/2)+1,                $zl       ,    int(($xl+$xu)/2),              $yu, int(($zl+$zu)/2) ); }
    #if ($box5 == $max) { find_max(                $xl,                $yl, int(($zl+$zu)/2)+1       ,    int(($xl+$xu)/2), int(($yl+$yu)/2),              $zu ); }
    #if ($box4 == $max) { find_max( int(($xl+$xu)/2)+1, int(($yl+$yu)/2)+1,                $zl       ,                 $xu,              $yu, int(($zl+$zu)/2) ); }
    #if ($box6 == $max) { find_max( int(($xl+$xu)/2)+1,                $yl, int(($zl+$zu)/2)+1       ,                 $xu, int(($yl+$yu)/2),              $zu ); }
    #if ($box7 == $max) { find_max(                $xl, int(($yl+$yu)/2)+1, int(($zl+$zu)/2)+1       ,    int(($xl+$xu)/2),              $yu,              $zu ); }
    #if ($box8 == $max) { find_max( int(($xl+$xu)/2)+1, int(($yl+$yu)/2)+1, int(($zl+$zu)/2)+1       ,                 $xu,              $yu,              $zu ); }

    if ($box1 >= $max_bot) { find_max(                $xl,                $yl,                $zl       ,    int(($xl+$xu)/2), int(($yl+$yu)/2), int(($zl+$zu)/2) ); }
    if ($box2 >= $max_bot) { find_max( int(($xl+$xu)/2)+1,                $yl,                $zl       ,                 $xu, int(($yl+$yu)/2), int(($zl+$zu)/2) ); }
    if ($box3 >= $max_bot) { find_max(                $xl, int(($yl+$yu)/2)+1,                $zl       ,    int(($xl+$xu)/2),              $yu, int(($zl+$zu)/2) ); }
    if ($box5 >= $max_bot) { find_max(                $xl,                $yl, int(($zl+$zu)/2)+1       ,    int(($xl+$xu)/2), int(($yl+$yu)/2),              $zu ); }
    if ($box4 >= $max_bot) { find_max( int(($xl+$xu)/2)+1, int(($yl+$yu)/2)+1,                $zl       ,                 $xu,              $yu, int(($zl+$zu)/2) ); }
    if ($box6 >= $max_bot) { find_max( int(($xl+$xu)/2)+1,                $yl, int(($zl+$zu)/2)+1       ,                 $xu, int(($yl+$yu)/2),              $zu ); }
    if ($box7 >= $max_bot) { find_max(                $xl, int(($yl+$yu)/2)+1, int(($zl+$zu)/2)+1       ,    int(($xl+$xu)/2),              $yu,              $zu ); }
    if ($box8 >= $max_bot) { find_max( int(($xl+$xu)/2)+1, int(($yl+$yu)/2)+1, int(($zl+$zu)/2)+1       ,                 $xu,              $yu,              $zu ); }
}

find_max(0,0,0,400000000,400000000,400000000);



#my @xcount = ();
#foreach my $b (@bots) {
#    for (my $x = $b->{x}-$b->{r}; $x <= $b->{x}+$b->{r} ; $x++ ) {
#	@xcount[200000000+$x]++;
#    }
#}    


exit;




for (my $i = $xmin; $i <= $xmax ; $i++ ) {
    
}

exit;
my %reach = ();
foreach my $a (@bots) {
    foreach my $b (@bots) {
        my $d = abs($b->{x}-$a->{x}) + abs($b->{y}-$a->{y}) + abs($b->{z}-$a->{z});
        #printf "The nanobot at %d,%d,%d is distance %d away, and so it is%s in range.\n" , $b->{x} , $b->{y} , $b->{z} , $d , $d <= $a->{r}? '': ' not';
        push @{$reach{$a->{i}}} , int $b->{i} if $d < $a->{r} + $b->{r};
    }
}



##foreach my $r (values %reach) {
##    printf "%d\n" , scalar @{$r};
##}
#
#my $rsum = 0;
#foreach my $b (@bots) {
#    $rsum += 1.0/$b->{r};
#}
#printf "rangesum: %d\n" , $rsum;
#
#foreach my $i ('x','y','z') {
#    my $sum = 0;
#    my $wsum = 0;
#    foreach my $b (@bots) {
#	$sum += $b->{$i};
#	$wsum += 1.0 * $b->{$i} / $b->{r};
#    }
#    printf "%s avg: %d\n" , $i , $sum/$#bots;
#    printf "%s avg: %d\n" , $i , $wsum/$rsum;
#}
#
##print to_json \%reach , {pretty=>1,canonical=>1};

