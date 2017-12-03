use v6.c;
use Test;
use Game::Sudoku;
use Game::Sudoku::Solver;

my $game = Game::Sudoku.new();
my $solved = solve-puzzle( $game );

is $solved.WHAT, Game::Sudoku, "We get a sudoku puzzle back";
is $solved.complete, False, "Can't complete an empty puzzle";


my %codes = (
    "003020600900305001001806400008102900700000008006708200002609500800203009005010300" =>
    "483921657967345821251876493548132976729564138136798245372689514814253769695417382",
    "904200007010000000000706500000800090020904060040002000001607000000000030300005702" =>
    "954213687617548923832796541763851294128974365549362178281637459475129836396485712",
);
for %codes.keys -> $code {
    $game = solve-puzzle( Game::Sudoku.new( :code($code) ) );
    
    ok $game.complete, "Game is complete";
    ok $game.valid,    "Game is valid";
    ok $game.full,     "Game is full";
    is $game.Str, %codes{$code}, "got expected value";
}

done-testing;
