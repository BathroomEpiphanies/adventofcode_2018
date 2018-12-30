use strict;
use warnings;
use JSON;
use Switch;
use List::Util qw(sum);

my @cave = ();
my @pawn = ();
my $pow = {E=>3,G=>3};
my $goblin_power = 0;
my $elf_power = 0;
my @dir = ({x=>0,y=>-1},{x=>-1,y=>0},{x=>1,y=>0},{x=>0,y=>1});
my $elf_start = 0;
    
sub read_cave {
    ($pow->{G},$pow->{E}) = <STDIN> =~ /(\d+)/g;
    my $y = 0;
    foreach (<STDIN>) {
        #chomp;
        my @list = split //;

        foreach my $i (0..$#list) {
            if ($list[$i] eq 'G') {
                my $g = {x=>$i,y=>$y,h=>200,a=>$pow->{G},r=>'G'};
                push @pawn , $g;
                $list[$i] = $g;
            }
            elsif ($list[$i] eq 'E') {
                my $e = {x=>$i,y=>$y,h=>200,a=>$pow->{E},r=>'E'};
                push @pawn , $e;
                $list[$i] = $e;
                $elf_start++;
            }
        }
        
        push @cave , \@list;
        $y++;
    }
}

sub print_cave {
    foreach my $y (0..$#cave) {
        my @hbar = ();
        foreach my $x (0..$#{$cave[0]}-1) {
            if (ref $cave[$y][$x]) {
                printf "%s" , $cave[$y][$x]->{r};
                push @hbar , $cave[$y][$x]->{h};
            }
            else {
                printf "%s" , $cave[$y][$x];
            }
        }
        print " @hbar \n";
    }
}


sub find {
    my $n = $_[0];

    # n is the pawn looking for destinations, he is in the search "origin"
    #
    # search hash element contains {x,y,d,o}
    # x,y  -  x,y-coordinte for squares in the cave
    # d    -  distance from search origin
    # o    -  first step taken from origin to get to the search element
    #
    # dest    -  list of possible destinations (search elements)
    #
    # search  -  2D array with search elements for x,y coordinates
    # queue   -  queue of search elements in the order found.

    my @dest = ();
    my @search = ();
    my @queue = ();

    # init search
    push @queue , $search[$n->{y}][$n->{x}] = {x=>$n->{x}, y=>$n->{y}, d=>0};

    while (@queue) {
        my $q = shift @queue;
        #print to_json $q , {pretty=>1,canonical=>1};
        my $X = $q->{x};
        my $Y = $q->{y};
        foreach my $o (@dir) {
            my $s = $search[$q->{y}+$o->{y}][$q->{x}+$o->{x}];
            if ( ! $s || $s->{d} > $q->{d}+1 ) {                                   # if square not already found, or with higher distance
                my $x = $X + $o->{x};
                my $y = $Y + $o->{y};
                if    ($cave[$y][$x] eq '#') {                                     # if cave[y][x] is wall, continue
                    next;
                }
                elsif (ref $cave[$y][$x] && $cave[$y][$x]->{r} ne $n->{r}) {       # if cave[y][x] is pawn and of opposite race, queue it to destinations found
                    return if $q->{d}==0;                                          # return null if already adjacent to opponent
                    push @dest , $q;
                } 
                elsif ($cave[$y][$x] eq '.') {                                     # if cave[y][x] is open space, expand search to surrounding squares, not yet found.
                    push @queue , $search[$y][$x] = { x=>$x, y=>$y, d=>$q->{d}+1, o=>$q->{o}||$o };
                }
            }
        }
    }

    # sort found destinations on distance and reading order
    @dest = sort { $a->{d} <=> $b->{d} or $a->{y} <=> $b->{y} or $a->{x} <=> $b->{x} } @dest;
    # Return the first destination (is undef if non-existant)
    return $dest[0];
}


sub hit {
    my $n = $_[0];
    my @opp = ();
    foreach my $o (@dir) {
        my $m = $cave[$n->{y}+$o->{y}][$n->{x}+$o->{x}];
        push @opp , $m if ref $m && $m->{r} ne $n->{r};
    }
    @opp = sort { $a->{h} <=> $b->{h} } @opp;
    #print to_json \@opp , {pretty=>1,canonical=>1};
    my $m = $opp[0];
    if ($m) {
        $m->{h} -= $n->{a};
        if ($m->{h} <= 0) {
            $m->{h} = 0;
            $cave[$m->{y}][$m->{x}] = '.';
        }
        return 1;
    }
    else {
        return 0;
    }
}

sub move {
    my $n = $_[0];
    my $d = find($n);

    my $action = 0;
    #print "$m,$o,$d\n";
    #print to_json $n , {pretty=>1,canonical=>1};
    if ($d) {
        $cave[$n->{y}][$n->{x}] = '.';
        $n->{x} += $d->{o}->{x};
        $n->{y} += $d->{o}->{y};
        $cave[$n->{y}][$n->{x}] = $n;
        $action = 1;
    }
    $action = 1 if hit($n);

    return $action;
}


read_cave();

sub run_turn {
    @pawn = sort {$a->{y} <=> $b->{y} or $a->{x} <=> $b->{x}} @pawn;
    return grep { $_->{h} > 0 && move($_) } @pawn;
}

for (my $turn = 0; $turn==0 || run_turn(); $turn++) {
    printf "Cave after turn: %d\n" , $turn;
    #map { printf "%s" , ref $_? $_->{r}: $_ } @{$_} foreach (@cave);
    print_cave();
}


printf "\ntotal hp remaining: %d\n" , sum map { $_->{h} } @pawn;

my $elf_end = grep { $_->{r} eq 'E' && $_->{h} > 0 } @pawn;
printf "elf count before/after: %d/%d\n" , $elf_start , $elf_end;
