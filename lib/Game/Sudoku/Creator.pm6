unit module Game::Sudoku::Creator;

use Game::Sudoku::Solver;
use Game::Sudoku;

sub create-puzzle() is export {
    return Game::Sudoku.new();
}
