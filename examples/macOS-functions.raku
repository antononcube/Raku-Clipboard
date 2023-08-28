#!/usr/bin/env raku
use v6.d;

use lib '.';
use lib './lib';

use Clipboard::macOS;

my (&pbcopy, &pbpaste) = init-osx-pbcopy-clipboard;

my %h = g => 1, h => 12;
pbcopy(%h);
say pbpaste;

say '=' x 120;

my $text = q:to/END/;
my %dictionary = (
    cat    => 'a small domesticated carnivorous mammal',
    dog    => 'a domesticated carnivorous mammal',
    chair  => 'a piece of furniture for seating',
    banana => 'a long curved fruit',
    apple  => 'a round fruit with red or green skin'
);
END

pbcopy($text);
say pbpaste;

