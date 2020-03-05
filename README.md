Name
====

String::Splice - splice, but for Strings instead of Arrays

Synopsis
========

```perl6
use String::Splice;

say 'Perl 6 is awesome'.splice(0, 6, 'Raku');
# Raku is awesome

say splice('This is Rakudo', *-2, 2);
# This is Raku

say "Tonight I'm gonna party like it's 1999"
  .splice(18, 5, 'program').splice(*-4, 2, 20);
# Tonight I'm gonna program like it's 2099
```

Description
===========

String::Splice is intended to give a simple interface to slicing and dicing Strings much in the same way that CORE Array.splice makes it easy to slice and dice Arrays.

Works very similarly on strings as the CORE splice works on Arrays.

Available as both a method (augmenting strings) or as a subroutine (that primarily operates on strings).

```perl6
multi sub    splice($String:D, $start, $chars?, $replacement = '' --> Str)
multi method splice($String:D: $start, $chars?, $replacement = '' --> Str)
```

The splice routine may be called with either three or four parameters.

Need to supply a defined string to operate on, a starting point (in chars), optionally the number of chars to affect, and an optional replacement string (defaults to ''). The starting point may be a positive integer, any Real numeric value that can be coerced to a positive integer, or a WhateverCode that will offset from the string end.

Use a WhateverCode if you want to modify a string some set offset from the end of an unknown length string rather than from the start.

`'Be home by 6:00PM'.splice(*-2, 1, 'A')` `# Be home by 6:00AM`

You may supply a start point larger than the string and the string will be padded with spaces to achieve that starting point.

`splice('Raku', 9, 'rocks')` is valid, as is `splice('Raku', *+5, 'rocks')`

The major difference in how String.splice differs from Array.splice is in that the starting position does not default to zero. It must be given.

Three parameter splice is mostly useful as an "insert" operation. You supply a receiving string, an "insert position" and a string to insert. The returned string will be the receiving string with the insertion string added at the start position. Technically, you could do a two argument splice, supplying a receiving string and a start position, and it will then insert a blank string at the start position, but that's kind-of pointless.

Four parameter splice is useful for remove or replace operations. You supply a receiving string, an "insert position", the number of characters to replace, and a string to insert. Remove portions of the string by replacing the substring with a blank, or change the string by replacing the substring with a different string.

The replace parameter does not necessarily need to be a string. Anything that may be coerced to a string may be supplied and will likely work as expected. When using 3 parameter splice: (String, start, insert), insert _must_ be a string to disambiguify the signature to the dispatcher. You can always use the four parameter form with a 0 chars parameter to get the automatic coercion.

Off topic musings
=================

I debated whether it was a good idea call this method/routine splice as splice is already used in core. The existing splice only works on Arrays and Bufs though, so there isn't much likelihood of confusion. I kicked around a few other name options (slice? dice?, nah, slice is already in use and not a very similar operation. dice maybe, but no historical corollation, and I really like the strange consistency between Array splice and String splice.)

Honestly, I am slightly surprised that something like this does not already exist in CORE what with Perls reputation as a text wrangling utility. I would be quite willing to contribute the idea and code if there were interest in folding it in. Better to start out as a module though to prove it out.

Author
======

Steve Schulze (thundergnat)

Copyright and License
=====================

Copyright 2020 Steve Schulze

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

