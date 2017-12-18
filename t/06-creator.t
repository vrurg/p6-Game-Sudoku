use v6.c;
use Test;
use Game::Sudoku::Creator;

# Calling create game will return a game
my $game = create-puzzle();
is $game.complete, False, "Game is not complete";
is $game.valid, True, "Game is valid";
is $game.full, False, "Game is not full";

done-testing;
