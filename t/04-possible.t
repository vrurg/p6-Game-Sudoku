use v6.c;
use Test;
use Game::Sudoku;

my $game = Game::Sudoku.new();
is $game.Str,( "0" x 81 ), "Nothing to see here";
is $game.possible(0,0).sort,(1...9),"Everything is possible";

is $game.set(0,0,1).Str,"1" ~ ( "0" x 80 ), "Setting returns the updated object";
is $game.possible(0,0).sort,(),"We have no options";
is $game.possible(0,1).sort,(2...9),"We have options";
is $game.valid, True, "Game state is valid";

is $game.set(0,0,2).Str,"2" ~ ( "0" x 80 ), "Now we have a cell";
is $game.possible(0,0).sort,(),"We have no options";
is $game.possible(0,1).sort,(1,3,4,5,6,7,8,9),"We have options";
is $game.valid, True, "Game state is valid";

is $game.set(1,0,2).Str,"22" ~ ( 0 x 79 ), "Still getting games";
is $game.valid, False, "Game state is invalid as we have 2 2's";
done-testing;
