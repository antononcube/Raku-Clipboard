use lib '.';
use lib './lib';

%*ENV<DISPLAY> = "Xvfb";

use Clipboard;
use Test;

plan *;

unless $*DISTRO.name ~~ /macos/ {
    skip-rest "MacOS specific tests";
    exit;
}

## 1
my $s1 = "3433";
copy-to-clipboard($s1);
is paste().trim, $s1;

## 2
my %h2 = g => 3, b => 565;
copy-to-clipboard(%h2);
#is paste().trim, %h2.raku;
is paste().trim, '${:b(565), :g(3)}';

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

copy-to-clipboard($s3);
is-deeply paste.trim, $s3.trim;

done-testing;
