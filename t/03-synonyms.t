use lib '.';
use lib './lib';

%*ENV<DISPLAY> = "Xvfb";

use Clipboard :cb-prefixed;
use Test;

plan *;

if $*DISTRO.name ~~ /macos/ {

    ## 1
    my $s1 = "3433";
    cbcopy($s1);
    is cbpaste().trim, $s1;

    ## 2
    my %h2 = g => 3, b => 565;
    cbcopy(%h2);
    is cbpaste().trim, '${:b(565), :g(3)}';

    ## 3
    my $s3 = q:to/END/;
my %dictionary = (
    cat    => 'a small domesticated carnivorous mammal',
    dog    => 'a domesticated carnivorous mammal',
    chair  => 'a piece of furniture for seating',
    banana => 'a long curved fruit',
    apple  => 'a round fruit with red or green skin'
);
END

    cbcopy($s3);
    is-deeply cbpaste.trim, $s3.trim;

} else {
    skip "Only MacOS specific tests.";
}

done-testing;
