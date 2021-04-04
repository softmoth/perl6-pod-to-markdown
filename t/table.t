use v6;

use Test;
use Pod::To::Markdown;

plan +$=pod;

my $ix = 0;

# Note that :caption('foo') doesn't do what it ought, because of
# this bug: https://rt.perl.org/Ticket/Display.html?id=130477
#
# Using <> is a hack, and were Pod parsing done correctly it could
# produce surprising results for more complex captions.

=for table :caption<Table 1>
H 1 | H 2 | H 3
====|=====|====
A A | B B | C C
1 1 | 2 2 | 3 3

is pod2markdown($=pod[$ix++]), q:to/EOF/, 'Basic table with explicit separators';
<table class="pod-table">
<caption>Table 1</caption>
<thead><tr>
<th>H 1</th> <th>H 2</th> <th>H 3</th>
</tr></thead>
<tbody>
<tr> <td>A A</td> <td>B B</td> <td>C C</td> </tr> <tr> <td>1 1</td> <td>2 2</td> <td>3 3</td> </tr>
</tbody>
</table>
EOF


=table
A A    B B       C C
1 1    2 2       3 3

is pod2markdown($=pod[$ix++]), q:to/EOF/, 'Whitespace delim, no header';
<table class="pod-table">
<tbody>
<tr> <td>A A</td> <td>B B</td> <td>C C</td> </tr> <tr> <td>1 1</td> <td>2 2</td> <td>3 3</td> </tr>
</tbody>
</table>
EOF


=begin pod
asdf
    =begin table :caption<Table 3>
               HHH
          H11  222  H 3
          ===  ===  ===
          AAA  BB   C C
                    C C

          1 1  2 2  3 3
               2 2
    =end table
asdf
=end pod

is pod2markdown($=pod[$ix++]), q:to/EOF/, 'Multi-line line table with space-separated rows';
asdf

<table class="pod-table">
<caption>Table 3</caption>
<thead><tr>
<th>H11</th> <th>HHH 222</th> <th>H 3</th>
</tr></thead>
<tbody>
<tr> <td>AAA</td> <td>BB</td> <td>C C C C</td> </tr> <tr> <td>1 1</td> <td>2 2 2 2</td> <td>3 3</td> </tr>
</tbody>
</table>

asdf
EOF


=for table :caption<Table 4>
Name      Title                  Info
Big Foot  I<Crypto>zoologist     L<Royal Society of London|https://skeptoid.com/blog/2014/07/07/bigfoot-of-the-gaps/>

todo('https://rt.perl.org/Ticket/Display.html?id=114480', 1);
is pod2markdown($=pod[$ix++]), q:to/EOF/, 'Table data are formatted as HTML';
<table class="pod-table">
<caption>Table 4</caption>
<tbody>
<tr> <td>Name</td> <td>Title</td> <td>Info</td> </tr> <tr> <td>Big Foot</td> <td><em>Crypto</em>zoologist</td> <td><a href="https://skeptoid.com/blog/2014/07/07/bigfoot-of-the-gaps/">Royal Society of London</a></td> </tr>
</tbody>
</table>
EOF

# Issue #26: This is a special-case hack, due to RT 114480 (Rakudo issue #2863)
=for table :caption<Entity Formatter Hack>
Name  | Formula                                     | Example           | Notes
---   | ---                                         | ---               | ---
frac  | x - E<0x230a>xE<0x230b>                     | frac(-1.3): 0.7   | 1
afrac | \|x\| - E<0x230a>\|x\|E<0x230b>             | afrac(-1.3): 0.3  | 2
ofrac | x - E<0x230a>\|x\|E<0x230b>E<0x22c5>sign(x) | ofrac(-1.3): -0.3 | 3

is pod2markdown($=pod[$ix++]),
    q:to/EOF/,
    <table class="pod-table">
    <caption>Entity Formatter Hack</caption>
    <thead><tr>
    <th>Name</th> <th>Formula</th> <th>Example</th> <th>Notes</th>
    </tr></thead>
    <tbody>
    <tr> <td>frac</td> <td>x - &#x230a;x&#x230b;</td> <td>frac(-1.3): 0.7</td> <td>1</td> </tr> <tr> <td>afrac</td> <td>|x| - &#x230a;|x|&#x230b;</td> <td>afrac(-1.3): 0.3</td> <td>2</td> </tr> <tr> <td>ofrac</td> <td>x - &#x230a;|x|&#x230b;&#x22c5;sign(x)</td> <td>ofrac(-1.3): -0.3</td> <td>3</td> </tr>
    </tbody>
    </table>
    EOF
    'Issue 26: Hack converts E<...> to &...; in table';

# vim:set ft=perl6:
