use v6.c;
use Test;
use String::Splice;

plan 28;

is(splice('', 0, 'Raku'), 'Raku', 'sub splice insert at 0 ok');
is(splice('Raku', 4, 'do'), 'Rakudo', 'sub splice insert at string end ok');
is(splice('Rakudo', 4, 'do'), 'Rakudodo', 'sub splice insert in interior ok');
is('Rakudo Perl 6 is awesome'.&splice(7, 6, 'Raku'), 'Rakudo Raku is awesome', 'sub splice with replace in interior is ok');
is('Rakudo Perl 6 is awesome'.&splice(7, 7), 'Rakudo is awesome', 'sub splice with blank replace in interior is ok');
is('Perl 5 is awesome'.&splice(5, 1, 6), 'Perl 6 is awesome', 'sub replace with non-string replace is ok');


is(''.splice(0, 'Raku'), 'Raku', 'method splice insert at 0 ok');;
is('Raku'.splice(4, 'do'), 'Rakudo', 'method splice insert at string end ok');
is('Rakudo'.splice(4, 'do'), 'Rakudodo', 'method splice insert in interior ok');
is('Rakudo Perl 6 is awsome'.splice(7, 6, 'Raku'), 'Rakudo Raku is awsome', 'method splice with replace in interior is ok');
is('Rakudo Perl 6 is awesome'.splice(7, 7), 'Rakudo is awesome', 'method splice with blank replace in interior is ok');
is('Perl 5 is awesome'.splice(5, 1, 6), 'Perl 6 is awesome', 'method replace with non-string replace is ok');

my $s = '';
my @calc = (^10).map: { $s.=flip.=splice($s.chars/2, "$_") };
my @ans = <0 10 021 1320 02431 135420 0246531 13576420 024687531 1357986420>;
for ^10 {
   is(@calc[$_], @ans[$_]);
}

is(''.splice(10, 'Raku'), '          Raku', 'splice past end works');
is('Rakudo'.splice(*-2, 'again'), 'Rakuagaindo', 'whatevercode works');
is('Rakudo'.splice(*-4, 2, 'bbits everywhere and nothing to '), 'Rabbits everywhere and nothing to do', 'whatevercode splice with replace works');

is('Rakudo'.splice(*+1, 'rocks'), 'Rakudo rocks','positive whatevercode works ok');

is('Rakudo'.splice(*+3, 'v2020.03'), 'Rakudo   v2020.03', 'positive whatevercode works ok');
is('Rakudo'.splice(*-1, 1, 'a'), 'Rakuda', 'whatevercode splice with replace works');

done-testing;
