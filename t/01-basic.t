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
is(splice(2222, 2, 0, 4), '22422', 'sub coerce numeric receiver to string works');
is(splice([<1 2 3 4>], 3, ' buckle my shoe,'), '1 2 buckle my shoe, 3 4', 'sub coerce array receiver to string works');

my $s = '';
my @calc = (^10).map: { $s.=flip.=&splice($s.chars/2, "$_") };
my @ans = <0 10 021 1320 02431 135420 0246531 13576420 024687531 1357986420>;
for ^10 {
   is(@calc[$_], @ans[$_], "chained methods, place coercion to Ints work ok: $_");
}

is(''.&splice(10, 'Raku'), '          Raku', 'splice past end works');
is('Rakudo'.&splice(*-2, ' again '), 'Raku again do', 'whatevercode works');
is('Rakudo'.&splice(*-4, 2, 'bbits everywhere and nothing to '), 'Rabbits everywhere and nothing to do', 'whatevercode splice with replace works');
is('Rakudo'.&splice(*+1, 'rocks'), 'Rakudo rocks','positive whatevercode works ok');
is('Rakudo'.&splice(*+3, 'v2020.03'), 'Rakudo   v2020.03', 'positive whatevercode past end works ok');
is('Rakudomania'.&splice(*-6, 1, 'a'), 'Rakudamania', 'whatevercode splice with replace works');
is('is going to be a mess...'.&splice(*-50, 'Hoo boy; '), 'Hoo boy; is going to be a mess...','too large negative whatevercode doesn\'t fail');

dies-ok({ splice('oops', -3, 'wh') }, 'negative start fails ok' );
dies-ok({ splice('Rakudo', 2, <ku rocks Ra>) }, '3 param non-string insert fails ok');
is( splice('Rakudo', 2, 0, <ku rocks Ra>) , 'Raku rocks Rakudo', '4 param non-string insert works ok');


done-testing;
