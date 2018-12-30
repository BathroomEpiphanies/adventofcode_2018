use strict;
use warnings;

use JSON;

chomp(my $line = <STDIN>);

#my %unit = ();
#foreach my $c (split // , $line) {
#    $unit{$c} = ();
#}

sub react {
    my ($polymer) = @_;
    my $old = 0;
    my $new = length $polymer;
    do {
        $old = $new;
        $polymer = $polymer =~ s/aA|bB|cC|dD|eE|fF|gG|hH|iI|jJ|kK|lL|mM|nN|oO|pP|qQ|rR|sS|tT|uU|vV|wW|xX|yY|zZ|Aa|Bb|Cc|Dd|Ee|Ff|Gg|Hh|Ii|Jj|Kk|Ll|Mm|Nn|Oo|Pp|Qq|Rr|Ss|Tt|Uu|Vv|Ww|Xx|Yy|Zz//gr;
        $new = length $polymer;
        #printf "%d\n" , length $polymer;
    } while ($new < $old);
    return $polymer;
}

my $polymer = react($line);
#print "$polymer";
printf "%d\n" , (length "$polymer");

my @pair = qw(a|A b|B c|C d|D e|E f|F g|G h|H i|I j|J k|K l|L m|M n|N o|O p|P q|Q r|R s|S t|T u|U v|V w|W x|X y|Y z|Z);

foreach my $p (@pair) {
    my $test = $line =~ s/$p//gr;
    $polymer = react($test);
    printf "%s %d %d\n" , $p , (length $test) , (length $polymer);
}

#print to_json \%unit, {pretty => 1, canonical => 1};
