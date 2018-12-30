use strict;
use warnings;
use JSON;
use Switch;

my %repair = ( '>'=>'-' , '<'=>'-' , '^'=>'|' , 'v'=>'|' );
my %turn =   ( '<'=>{l=>'v',s=>'<',r=>'^'} ,
               '>'=>{l=>'^',s=>'>',r=>'v'} ,
               'v'=>{l=>'>',s=>'v',r=>'<'} ,
               '^'=>{l=>'<',s=>'^',r=>'>'} );
my %new =    ( 'l'=>'s' , 's'=>'r' , 'r'=>'l' );

#print to_json \%repair , {pretty=>1};
#print to_json \%turn , {pretty=>1};
#print to_json \%new , {pretty=>1};
#exit;

sub print_map {
    print $_."\n" foreach @_;
    print "\n";
}


CASE: while (my $line = <STDIN>) {
    print "Next test case:\n";
    chomp($line);
    
    my $y = 0;
    my @cart = ();
    my %track = ();
    my @map = ();
    my @print = ();
    
    while (length $line != 0) {
        #print "$line\n";
        $map[$y] = $line;
        $print[$y] = $line;
        $map[$y] =~ s/[<>]/-/g;
        $map[$y] =~ s/[v^]/|/g;
        my $x = 0;
        foreach my $c (split '' , $line) {
            if ($repair{$c}) {
                push @cart , { d=>$c , x=>$x , y=>$y , l=>'r' };
                $track{$x}{$y} = $repair{$c};
            }
            elsif (! $c eq ' ') {
                $track{$x}{$y} = $c;
            }
            $x++;
        }
        $y++;

        $line = <STDIN>;
        chomp($line);
    }
    
    
    print to_json \@cart , {pretty=>1};
    
    print_map(@print);

    #for (my $step = 1; $step <= 10; $step++) {
    while (1) {
        @cart = sort {$a->{x} <=> $b->{x} or $a->{y} <=> $b->{y}} @cart;
        foreach my $i (0..$#cart) {
            my %c = %{$cart[$i]};
            #print to_json \%c; print"\n";
            my $m = substr $map[$c{y}] , $c{x} , 1;
            substr @print[$c{y}] , $c{x} , 1 , (substr @map[$c{y}], $c{x} , 1);
            if ($m eq '+') {
                my $l = $c{l};
                $c{l} = $new{$l}; 
                $c{d} = $turn{$c{d}}{$c{l}};
            }
            switch ($c{d}) {
                case '<' {
                    switch ($m) {
                        case '-'  {$c{x}--;}
                        case '\\' {$c{y}--; $c{d} = '^';}
                        case '/'  {$c{y}++; $c{d} = 'v';}
                        case '+'  {$c{x}--;}
                    }
                }
                case '>' {
                    switch ($m) { 
                        case '-'  {$c{x}++;}
                        case '\\' {$c{y}++; $c{d} = 'v';}
                        case '/'  {$c{y}--; $c{d} = '^';}
                        case '+'  {$c{x}++;}
                    }
                }
                case 'v' {
                    switch ($m) { 
                        case '|'  {$c{y}++;}
                        case '\\' {$c{x}++; $c{d} = '>';}
                        case '/'  {$c{x}--; $c{d} = '<';}
                        case '+'  {$c{y}++;}
                    }
                }
                case '^' {
                    switch ($m) { 
                        case '|'  {$c{y}--;}
                        case '\\' {$c{x}--; $c{d} = '<';}
                        case '/'  {$c{x}++; $c{d} = '>';}
                        case '+'  {$c{y}--;}
                    }
                }
            }
            
            #print to_json \%c; print"\n";
            if ((substr $print[$c{y}] , $c{x} , 1) =~ /[v\^<>]/) {
                substr $print[$c{y}] , $c{x} , 1 , 'X';
                print_map(@print);
                printf "Crash!! at %d,%d\n\n" , $c{x} , $c{y};
                next CASE;
            }
            substr $print[$c{y}] , $c{x} , 1 , $c{d};
            $cart[$i] = \%c;
        }

        print_map(@print);
    }
    
    
}
