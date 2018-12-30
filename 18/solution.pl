use strict;
use warnings;
use Time::HiRes qw(usleep);
    
my @forest = ();
foreach (<STDIN>) {
    chomp;
    push @forest , [split // , '.'.$_.'.'];
}

push    @forest , [split // , '.' x @{$forest[0]}];
unshift @forest , [split // , '.' x @{$forest[0]}];

my $ymax = $#forest;
my $xmax = $#{$forest[0]};

my @next = map { [@$_] } @forest;
sub grow {
    for (my $y = 1; $y < $ymax; $y++) {
        for (my $x = 1; $x < $xmax; $x++) {
            my @area = (@{$forest[$y-1]}[($x-1,$x,$x+1)] , @{$forest[$y]}[($x-1,$x+1)] , @{$forest[$y+1]}[($x-1,$x,$x+1)]);
            if    ($forest[$y][$x] eq '.') {
                $next[$y][$x] = (3 <= grep { $_ eq '|' } @area)? '|': '.';
            }
            elsif ($forest[$y][$x] eq '|') {
                $next[$y][$x] = (3 <= grep { $_ eq '#' } @area)? '#': '|';
            }
            elsif ($forest[$y][$x] eq '#') {
                $next[$y][$x] = (1 <= grep { $_ eq '#' } @area) && (1 <= grep { $_ eq '|' } @area)? '#': '.';
            }
            #else {
            #    $next[$y][$x] = $forest[$y][$x];
            #}
        }
    }
    my @swap = @forest;
    @forest = @next;
    @next = @swap;
}

my $maxiter = 1000000000000;
for (my $i = 0; $i < $maxiter; $i++) {
    #if( $i % 100000 == 0 ) { print "$i\n"; }
    my $tree = map { grep { $_ eq '|' } @{$_} } (@forest);
    my $yard = map { grep { $_ eq '#' } @{$_} } (@forest);

    printf "after %d iterations, trees: %d, yard: %d, product %d\n" , $i , $tree , $yard , $tree*$yard;
    printf "%s\n" , join '' , @{$_} foreach (@forest); print "\n";
    #printf "%d,%d\n" , $i , $tree*$yard;

    #usleep(500000);
    usleep(100000);
    grow();
    #print @{$_}."\n" foreach (@forest); print "\n";

}


my $tree = map { grep { $_ eq '|' } @{$_} } (@forest);
my $yard = map { grep { $_ eq '#' } @{$_} } (@forest);
printf "after %d iterations, trees: %d, yard: %d, product %d\n" , $maxiter , $tree , $yard , $tree*$yard;
printf "%s\n" , join '' , @{$_} foreach (@forest); print "\n";
