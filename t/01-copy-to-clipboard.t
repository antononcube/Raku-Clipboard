use lib '.';
use lib './lib';

%*ENV<DISPLAY> = "Xvfb";

use Clipboard;
use Test;

plan *;

if $*DISTRO.name ~~ /macos/ {

    ## 1
    my $s1 = "3433";
    is-deeply copy-to-clipboard($s1), $s1;

    ## 2
    my %h2 = g => 3, b => 565;
    is-deeply copy-to-clipboard(%h2), %h2;

} else {
    skip "Only MacOS specific tests.";
}

done-testing;
