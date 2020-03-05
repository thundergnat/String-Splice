use v6.c;
unit module Str::Splice:ver<0.0.1>:auth<github:thundergnat>;
use nqp;

role Splice {
    multi method splice (Str:D: Int(Real) $start, Int(Real) $chars, Str(Any) $add = '' --> Str) {
        fail "Start offset ($start) must be positive" if $start < 0;
        fail "Characters ($chars) must be positive" if $chars < 0;
        splice-it(self, $start, $chars, $add)
    }

    multi method splice (Str:D: Int(Real) $start, Str $add = '' --> Str) {
        fail "Start offset ($start) can not be negative" if $start < 0;
        fail "Last parameter ($add) must be a string" unless $add.^name ~~ Str;
        splice-it(self, $start, 0, $add)
    }

    multi method splice (Str:D: WhateverCode $w, Int(Real) $chars, Str(Any) $add = '' --> Str) {
        fail "Last parameter ($add) must be a string" unless $add.^name ~~ Str;
        splice-it(self, (self.chars).&($w), $chars, $add)
    }

    multi method splice (Str:D: WhateverCode $w, Str $add = '' --> Str) {
        fail "Last parameter ($add) must be a string" unless $add.^name ~~ Str;
        splice-it(self, (self.chars).&($w), 0, $add)
    }
}

proto sub splice (Str $, |c) is pure {*};

multi splice ($str, Int(Real) $start, Int(Real) $chars, Str(Any) $add = '' --> Str) is export {
    fail "Start offset ($start) can not be negative" if $start < 0;
    fail "Characters ($chars) must be positive" if $chars < 0;
    splice-it($str, $start, $chars, $add)
}

multi splice ($str, Int(Real) $start, Str $add = '' --> Str) is export {
    fail "Start offset ($start) can not be negative" if $start < 0;
    fail "Last parameter ($add) must be a string" unless $add.^name ~~ Str;
    splice-it($str, $start, 0, $add)
}

multi splice ($str, WhateverCode $w, Int(Real) $chars, Str(Any) $add = '' --> Str) is export {
    fail "Characters ($chars) must be positive" if $chars < 0;
    splice-it($str, ($str.chars).&($w), $chars, $add)
}

multi splice ($str, WhateverCode $w, Str $add = '' --> Str) is export {
    fail "Last parameter ($add) must be a string" unless $add.^name ~~ Str;
    splice-it($str, ($str.chars).&($w), 0, $add)
}

sub splice-it ($str, $start, $chars = 0, $add = '') {
    $str.chars < $start ??
    ($str ~  ' ' x $start - $str.chars ~ $add) !!
    (nqp::substr($str, 0, $start) ~ $add ~ nqp::substr($str, $start + $chars))
}

use MONKEY-TYPING;

augment class Str does Splice { }


=begin pod

=head1 NAME

String::Splice - Splice; but for Strings instead of Arrays

=head1 SYNOPSIS

=begin code :lang<perl6>

use String::Splice;

say 'Perl 6 is awesome'.splice(0, 6, 'Raku');
# Raku is awesome

say 'This is Rakudo'.splice(*-2, 2);
# This is Raku

say "Tonight I'm gonna party like it's 1999"
  .splice(18, 5, 'program').splice(*-4, 2, 20);
# Tonight I'm gonna program like it's 2099

=end code

=head1 DESCRIPTION

String::Splice is intended to give a simple interface to slicing and dicing
Strings  much in the same way that CORE Array.splice makes it easy to slice and
dice Arrays.

Works very similarly on strings as the CORE splice works on Arrays.

Available as both a method (augmenting strings) or as a subroutine (that
primarily operates on strings).

=begin code :lang<perl6>

multi sub    splice($String:D, $start, $chars?, Str $replacement = '' --> Str)
multi method splice($String:D: $start, $chars?, Str $replacement = '' --> Str)

=end code

Need to supply a defined string to operate on, a starting point (in chars),
optionally the number of chars to affect, and an optional replacement string
(defaults to ''). The starting point may be a positive integer, any Real numeric
value that can be coerced to a positive integer, or a WhateverCode that will
offset from the string end.

Use a WhateverCode if you want to modify a string some set offset from the end
of an unknown length string rather than from the start.

C<'Be home by 6:00PM'.splice(*-2, 1, 'A')> # Be home by 6:00AM

You may supply a start point larger than the string and the string will be
padded with spaces to achieve that starting point.

C<splice('Raku', 9, 'rocks')> is valid, as is C<splice('Raku', *+5, 'rocks')>
# Raku     rocks

The major difference in how String.splice differs from Array.splice is in that
the starting position does not default to zero. It must be given.

When using 4 argument splice: (String, start, chars, replace) the replace
parameter does not need to ba a string. Anything that may be coerced to a string
may be used. With 3 argument splice: (String, start, replace), replace MUST be a
string to disambiguify the signature to the dispatcher.


=head1 AUTHOR

Steve Schulze (thundergnat)

=head1 COPYRIGHT AND LICENSE

Copyright 2020 Steve Schulze

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
