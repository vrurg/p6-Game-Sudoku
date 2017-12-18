use v6.c;
use Test;
use Game::Sudoku::Creator;

# Calling create game will return a game
my $game = create-puzzle();
is $game.complete, False, "Game is not complete";
is $game.valid, True, "Game is valid";
is $game.full, False, "Game is not full";

ok $game.Str.comb.grep(* > 0).elems > 0, "We have at least 1 non 0 value in the game";

my $game2 = create-puzzle();
isnt $game.Str, $game2.Str, "We should not create the same puzzle twice";

done-testing;
