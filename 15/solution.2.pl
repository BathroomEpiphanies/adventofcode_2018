use strict;
use warnings;
use JSON;
use Switch;
#use List::PriorityQueue;

my @cave = ();
my $goblin_power = 0;
my $elf_power = 0;
my @goblin = ();
my @elf = ();
my @dir = ({x=>0,y=>-1},{x=>-1,y=>0},{x=>1,y=>0},{x=>0,y=>1});

sub read_cave {
    my $y = 0;
    while (my $line = <STDIN>) {
        chomp($line);
        last if length($line) == 0;
        my @list = split // , $line;

        foreach my $i (0..$#list) {
            if ($list[$i] eq 'G') {
                my $g = {x=>$i,y=>$y,h=>200,a=>$goblin_power,r=>'G'};
                push @goblin , $g;
                $list[$i] = $g;
            }
            elsif ($list[$i] eq 'E') {
                my $e = {x=>$i,y=>$y,h=>200,a=>$elf_power,r=>'E'};
                push @elf , $e;
                $list[$i] = $e;
            }
        }
        
        push @cave , \@list;
        $y++;
    }
}

sub print_cave {
    foreach my $y (0..$#cave) {
        my @hbar = ();
        foreach my $x (0..$#{$cave[0]}) {
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

sub print_dist {
    my $dp = $_[0];
    my @dist = @$dp;
    #foreach my $y (0..$#dist) {
    #    foreach my $x (0..$#{$dist[0]}) {
    foreach my $y (0..$#cave) {
        foreach my $x (0..$#{$cave[0]}) {
            if ($cave[$y][$x] ne '.') {
                printf "% 2s " , $cave[$y][$x];
            }
            elsif ($dist[$y][$x]) {
                printf "%2d " , $dist[$y][$x];
            }
            else {
                printf "% 2s " , 'X';
            }
        }
        print"\n";
    }
}



sub hit {

    return 0;
}

sub find {
    my $n = $_[0];

    my @enemy = ();

    my @dist = ();
    my @queue = ();
    
    $dist[$n->{y}][$n->{x}] = -1;
    $dist[$n->{y}+$_->{y}][$n->{x}+$_->{x}] = 1 foreach @dir;
    push @queue , [$n->{x}+$_->{x},$n->{y}+$_->{y},$_] foreach @dir;


    #return;
    my $x = $n->{x};
    my $y = $n->{y};
    my $o;
    while (@queue) {
        ($x,$y,$o) = @{shift @queue};
        if    ($cave[$y][$x] eq '#') { next; }
        elsif (ref $cave[$y][$x] && $cave[$y][$x]->{r} ne $n->{r}) { push @enemy , [$cave[$y][$x],$o,$dist[$y][$x]]; }
        #elsif (ref $cave[$y][$x] && $cave[$y][$x]->{r} eq 'E') { push @enemy , [$cave[$y][$x],$o,$dist[$y][$x]] if ($n->{r} eq 'G'); }
        elsif ($cave[$y][$x] eq '.') {
            foreach my $d (@dir) {
                if ( ! $dist[$y+$d->{y}][$x+$d->{x}] || $dist[$y+$d->{y}][$x+$d->{x}] > $dist[$y][$x]+1) {
                    push @queue , [$x+$d->{x},$y+$d->{y},$o];
                    $dist[$y+$d->{y}][$x+$d->{x}] = $dist[$y][$x]+1;
                }
            }
        }
    }

    @enemy = sort {$a->[2] <=> $b->[2] or $a->[0]->{y} <=> $b->[0]->{y} or $a->[0]->{x} <=> $b->[0]->{x}} @enemy;
    #print to_json $enemy[0] , {pretty=>1,canonical=>1};
    
    if($enemy[0]) {
        return @{$enemy[0]};
    }
    else {
        return ({},{},0);
    }
}


sub move {
    my $n = $_[0];
    my ($m,$o,$d) = find($n);
    #print "$m,$o,$d\n";
    #print to_json $n , {pretty=>1,canonical=>1};
    if ($d>1) {
        $cave[$n->{y}][$n->{x}] = '.';
        $n->{x} += $o->{x};
        $n->{y} += $o->{y};
        $cave[$n->{y}][$n->{x}] = $n;
    }
    if ($d != 0 && $d < 3) {

        my @enemy = ();
        
        foreach my $p (@dir) {
            my $k = $cave[$n->{y}+$p->{y}][$n->{x}+$p->{x}];
            if (ref $k && $k->{r} ne $n->{r} ) {
                push @enemy , [$k,$p,1];
            }
        }
        
        #print to_json \@enemy , {pretty=>1,canonical=>1};
        
        if (scalar @enemy) {
            @enemy = sort {$a->[0]->{h} <=> $b->[0]->{h} or $a->[0]->{y} <=> $b->[0]->{y} or $a->[0]->{x} <=> $b->[0]->{x}} @enemy;
        }
        
        ($m,$o,$d) = @{$enemy[0]};
        
        #print to_json $m , {pretty=>1,canonical=>1};
        #print "\n\n";
        $m->{h} -= $n->{a};
        if ($m->{h} <= 0) {
            $m->{h} = 0;
            $cave[$m->{y}][$m->{x}] = '.';
        }
        return 1;
    }
    return $d>0? 1: 0;

}


my $line = <STDIN>;
($goblin_power,$elf_power) = $line =~ /(\d+)/g;
read_cave();
push @goblin , @elf;
my @nisse = @goblin;
@nisse = sort {$a->{y} <=> $b->{y} or $a->{x} <=> $b->{x}} @nisse;

my $elf_start = scalar @elf;
#print to_json \@nisse , {pretty=>1,canonical=>1};


my $test = 1;
my $ turn = 0;
print "turn: $turn\n";
print_cave();
while ($test) {
    $turn++;
    print "turn: $turn\n";
    $test = 0;
    @nisse = sort {$a->{y} <=> $b->{y} or $a->{x} <=> $b->{x}} @nisse;
    foreach my $n (@nisse) {
        if($n->{h}>0) {
            $test = move($n) || $test;
        }
        #print "test: $test\n";
        #print_cave();
    }
    print_cave();
}

my $sum = 0;
foreach my $n (@nisse) {
    $sum += $n->{h};
}
print "$turn $sum\n";

my $elf_end = 0;
foreach my $n (@nisse) {
    if ($n->{r} eq 'E' && $n->{h} > 0) {
        $elf_end++;
    }
}
printf "elf count: before %d, after %d\n" , $elf_start , $elf_end;
