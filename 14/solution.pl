use strict;
use warnings;
use JSON;

chomp(my $n = <STDIN>);
my @recipe = (3,7);
my $elf1 = 0;
my $elf2 = 1;

while (scalar @recipe < $n+10) {
    #print "@recipe\n";
    my $new = $recipe[$elf1] + $recipe[$elf2];
    splice @recipe , scalar @recipe , 0 , split '' , $new;
    $elf1 = ($elf1 + 1 + $recipe[$elf1]) % scalar @recipe;
    $elf2 = ($elf2 + 1 + $recipe[$elf2]) % scalar @recipe;
}

printf "Scores of last %d recipes: %s\n" , $n , join '' , @recipe[$#recipe-9..$#recipe];




@recipe = (3,7);
$elf1 = 0;
$elf2 = 1;
my $m = length $n;

while (1) {
    my $new = $recipe[$elf1] + $recipe[$elf2];
    push @recipe , (split '' , $new);
    $elf1 = ($elf1 + 1 + $recipe[$elf1]) % scalar @recipe;
    $elf2 = ($elf2 + 1 + $recipe[$elf2]) % scalar @recipe;
    
    last if ((join '' , @recipe[$#recipe-$m+1..$#recipe]) eq $n);
    last if ((join '' , @recipe[$#recipe-$m..$#recipe-1]) eq $n);
}

if ((join '' , @recipe[$#recipe-$m+1..$#recipe]) eq $n) {
    printf "Number of recipes before string found: %d\n" , scalar @recipe-$m;
}
else {
    printf "Number of recipes before string found: %d\n" , scalar @recipe-$m-1;
}
