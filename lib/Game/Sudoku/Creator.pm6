unit module Game::Sudoku::Creator;

use Game::Sudoku::Solver;
use Game::Sudoku;

sub create-puzzle() is export {
    Game::Sudoku.new().cell(0,0,1).cell((1..8).pick,(1..8).pick,2);
}
