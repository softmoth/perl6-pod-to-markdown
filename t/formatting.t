use Test;
use Pod::To::Markdown;
plan 1;

=begin pod
This text is of U<minor significance>.

This text is of I<major significance>.

This text is of B<fundamental significance>.

This text is V<verbatim C<with> B<disarmed> Z<formatting>>.

This text is R<to be replaced>.

This text is Z<blabla>invisible.

This text contains a link to L<https://raku.org/>.

This text contains a bare fragment link L<#anchor>.

This text contains a link with label to L<TPF|https://perlfoundation.org/>.

And awesome L<link B<with I<formatting>>|http://p6weekly.wordpress.com/>!
=end pod

is pod2markdown($=pod), q:to/EOF/, 'Decodes formatted text correctly';
This text is of _minor significance_.

This text is of *major significance*.

This text is of **fundamental significance**.

This text is verbatim C<with> B<disarmed> Z<formatting>.

This text is <var>to be replaced</var>.

This text is invisible.

This text contains a link to [https://raku.org/](https://raku.org/).

This text contains a bare fragment link [anchor](#anchor).

This text contains a link with label to [TPF](https://perlfoundation.org/).

And awesome [link **with *formatting***](http://p6weekly.wordpress.com/)!
EOF

# vim:set ft=raku:
