use v6.d;

use lib '.';
use lib './lib';

use Clipboard;
use Test;

## 1
ok copy-to-clipboard("3433");

## 2
my %h2 = g => 3, b => 565;
ok copy-to-clipboard(%h2);

done-testing;
