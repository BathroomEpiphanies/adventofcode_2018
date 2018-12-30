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
    my @cart = ();
    
    my $y = 0;
    while (length $line != 0) {
        my @check = split '' , $line;
        foreach my $x (0..$#check) {
            if ($check[$x] =~ m/[v\^<>]/) {
                push @cart , { d=>$check[$x] , x=>$x , y=>$y , l=>'r' ,z=>0 };
            }
        }
        $line =~ tr/v^<>/||\-\-/;
        
        @track[$y] = [ split '' , $line ];
        $y++;
        $line = <STDIN>;
        chomp($line);
    }
    return (\@track,\@cart);
}

sub print_track {
    `clear`;
    my ($track,$cart) = @_;
    
    my @output = @{clone($track)};
    $output[$_->{y}][$_->{x}] = $_->{d} foreach @$cart;
    
    print join( '' , @$_) . "\n" foreach @output;
}

sub move {
    my ($c,$t,$cart) = @_;
    #print "turn $c->{d} $t\n";

    return if ($$c{z});
    
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

    switch ($c->{d}) {
        case 'v' { $c->{y}++; }
        case '^' { $c->{y}--; }
        case '<' { $c->{x}--; }
        case '>' { $c->{x}++; }
    }

    foreach my $d (@$cart) {
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

    print_track(\@track,\@cart);

    my $step=0;
    while ($#cart > 0) {
        $step++;

        @cart = sort { $a->{y} <=> $b->{y} or $a->{x} <=> $b->{x} } @cart;
        
        move($_,$track[%$_{y}][%$_{x}],\@cart) foreach @cart;
        @cart = grep { ! $$_{z} } @cart;
        
        print_track(\@track,\@cart);
    }

    if ($#cart >= 0) { 
        printf "Last cart at %d,%d after %d steps\n\n\n" , $cart[0]->{x} , $cart[0]->{y} , $step;
    }
    else {
        printf "All carts crashed after %d steps\n\n\n" , $step;
    }
    #print to_json \@cart; print "\n";
    
    #last;
    
}
