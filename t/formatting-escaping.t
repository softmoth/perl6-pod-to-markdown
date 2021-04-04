use Test;
use Pod::To::Markdown;
plan 1;

is pod2markdown($=pod), q:to/EOF/, 'Properly deals with code that contains backticks in it';
Here is a single backtick `` ` ``.

Here is two backticks ``` `` ```.

Here is one ```` ```raku```` with three.
EOF


=begin pod
Here is a single backtick C<`>.

Here is two backticks C<``>.

Here is one C<```raku> with three.
=end pod

# vim:set ft=raku:
