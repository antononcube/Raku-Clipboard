use v6.d;

use lib '.';
use lib './lib';

use Clipboard;
use Test;

## 1
my $s1 = "3433";
copy-to-clipboard($s1);
is from-clipboard().trim, $s1;

## 2
my %h2 = g => 3, b => 565;
copy-to-clipboard(%h2);
#is from-clipboard().trim, %h2.raku;
is from-clipboard().trim, '${:b(565), :g(3)}';

done-testing;
