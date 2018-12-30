use strict;
use warnings;
use JSON;
use Switch;
use Clone qw(clone);
#use Term::ANSIScreen qw(cls);

my %repair = ( '>'=>'-' , '<'=>'-' , '^'=>'|' , 'v'=>'|' );
my %next   = ( 'l'=>'s' , 's'=>'r' , 'r'=>'l' );
my %turn   = ( '<'=>{l=>'v',s=>'<',r=>'^'} ,
               '>'=>{l=>'^',s=>'>',r=>'v'} ,
               'v'=>{l=>'>',s=>'v',r=>'<'} ,
               '^'=>{l=>'<',s=>'^',r=>'>'} );

#print to_json \%repair , {pretty=>1};
#print to_json \%turn , {pretty=>1};
#print to_json \%new , {pretty=>1};
#exit;

sub read_track {
    my $line = $_[0];
    my @track = ();
    my @cart = ({x=>-1,y=>-1,d=>' ',l=>' ',z=>0});
    
    my $y = 0;
    while (length $line != 0) {
        my @list = split '' , $line;
        foreach my $x (0..$#list) {
            if ($repair{$list[$x]}) {
                push @cart , { d=>$list[$x] , x=>$x , y=>$y , l=>'r' ,z=>0 };
                $list[$x] = $repair{$list[$x]};
            }
        }
        @track[$y] = \@list;
        $y++;
        $line = <STDIN>;
        chomp($line);
    }
    return (\@track,\@cart);
}

sub print_track {
    `clear`;
    my ($track,$cart) = @_;
    #print to_json \@$track , {pretty=>1};
    #print to_json \@$cart , {pretty=>1};

    my @output = @{clone($track)};
    $output[$_->{y}][$_->{x}] = $_->{d} foreach @$cart[1..$#{$cart}];

    #print to_json \@$output , {pretty=>1};
    print join( '' , @$_) . "\n" foreach @output;
}

sub turn {
    my ($c,$t) = @_;
    #print "turn $c->{d} $t\n";

    switch ($t) {
        case '+' {
            my $l = $c->{l};
            $c->{l} = $next{$l};
            $c->{d} = $turn{$c->{d}}{$c->{l}};
        }
        case '\\' {
            switch ($c->{d}) {
                case 'v' { $c->{d} = '>'; }
                case '^' { $c->{d} = '<'; }
                case '<' { $c->{d} = '^'; }
                case '>' { $c->{d} = 'v'; }
            }
        }
        case '/' {
            switch ($c->{d}) {
                case 'v' { $c->{d} = '<'; }
                case '^' { $c->{d} = '>'; }
                case '<' { $c->{d} = 'v'; }
                case '>' { $c->{d} = '^'; }
            }
        }
    }
}

sub move {
    my ($c,$cc) = @_;
    #print to_json \%$c; print "\n";

    if($$c{z}) {
        return 0;
    }
    
    switch ($c->{d}) {
        case 'v' { $c->{y}++; }
        case '^' { $c->{y}--; }
        case '<' { $c->{x}--; }
        case '>' { $c->{x}++; }
    }

    foreach my $d (@$cc[1..$#{$cc}]) {
        next if $c == $d || $d->{z};
        #print to_json \%$d; print "\n";
        if ( $c->{x} == $d->{x} && $c->{y} == $d->{y} ) {
            printf "Collision %d,%d\n" , $c->{x} , $c->{y};
            $c->{z} = 1;
            $d->{z} = 1;
            last;
        }
    }
}

while (my $line = <STDIN>) {
    print "Next test case:\n";
    chomp($line);
    
    my ($r1,$r2) = read_track($line);
    my @track = @$r1;
    my @cart = @$r2;
    #my (@track,@cart) = read_track($line);

    #print_track(\@track,\@cart); print "\n";

    my $step=0;
    while ($#cart > 1) {
        $step++;

        @cart = sort { $a->{y} <=> $b->{y} or $a->{x} <=> $b->{x} } @cart;
        
        turn($_,$track[%$_{y}][%$_{x}]) foreach @cart[1..$#cart];
        move($_,\@cart) foreach @cart[1..$#cart];
        @cart = grep { ! $$_{z} } @cart;
        
        #print_track(\@track,\@cart); print "\n";
    }

    printf "Last cart at %d,%d after %d steps\n" , $cart[1]->{x} , $cart[1]->{y} , $step;
    #print to_json \@cart; print "\n";
    
    #last;
    
}
