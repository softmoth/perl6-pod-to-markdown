use Test;
use Pod::To::Markdown;

plan 2;

=begin code :lang<raku> :allow<B I>
say "B<Here is some Raku code!>";

say "Here is another line here";

exit 0;
=end code

=begin code :allow<B I>
Some code I<without> lang set here
=end code

is pod2markdown($=pod), q:to/EOF/, 'Pod with lang set renders correctly';
```raku
say "Here is some Raku code!";

say "Here is another line here";

exit 0;
```

    Some code without lang set here
EOF

is pod2markdown($=pod, :no-fenced-codeblocks), q:to/EOF/, 'Pod with lang and :no-fenced-codeblocks renders correctly';
    say "Here is some Raku code!";

    say "Here is another line here";

    exit 0;

    Some code without lang set here
EOF

# vim:set ft=raku:
