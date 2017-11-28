use v6.c;
use Test;
use Game::Sudoku;

# Empty board
my $game = Game::Sudoku.new();
is $game.Str, '0' x 81, "String rep is 81 0's";
my $expected =
"   |   |   \n"~
"   |   |   \n"~
"   |   |   \n"~
"---+---+---\n"~
"   |   |   \n"~
"   |   |   \n"~
"   |   |   \n"~
"---+---+---\n"~
"   |   |   \n"~
"   |   |   \n"~
"   |   |   ";

is $game.gist, $expected, "Grid is as expected";
is $game.valid, True, "Empty grid is valid";
is $game.complete, False, "Empty grid is not complete";   

$game = Game::Sudoku.new( code => ( "1" ~ ( "0" x 80 ) ) );
$expected =
"1  |   |   \n"~
"   |   |   \n"~
"   |   |   \n"~
"---+---+---\n"~
"   |   |   \n"~
"   |   |   \n"~
"   |   |   \n"~
"---+---+---\n"~
"   |   |   \n"~
"   |   |   \n"~
"   |   |   ";

is $game.Str, '1' ~ ( '0' x 80 ), "String rep is as expected";
is $game.gist, $expected, "Grid is as expected";

is $game.valid, True, "Grid is valid";
is $game.complete, False, "Grid is not complete";   

say $game.perl;

done-testing;
