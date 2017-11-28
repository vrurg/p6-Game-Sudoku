use v6.c;

class Game::Sudoku:ver<0.0.1>:auth<simon.proctor@gmail.com> {

    subset GridCode of Str where *.chars == 81;
    
    has @!grid; 
    
    multi submethod BUILD( GridCode :$code = ("0" x 81) ) {
        my @tmp = $code.comb;
        for ^9 -> $y {
            for ^9 -> $x {
                @!grid[$y][$x] = @tmp[($y*9)+$x]; 
            }
        }
    }
    
    multi method Str {
        return @!grid.map( -> @row { @row.join("") } ).join( "" );
    }
    
    multi method gist {
        my @lines;
        for ^9 -> $y {
            my @row;
            for ^9 -> $x {
                @row.push( @!grid[$y][$x] > 0 ?? @!grid[$y][$x] !! ' ' );
                @row.push( "|" ) if $x == 2|5;
            }
            @lines.push( @row.join("") );
            @lines.push( "---+---+---" ) if $y == 2|5;
        }
        return @lines.join( "\n" );
    }

    multi method valid { True; }
    multi method complete { False; }
}

=begin pod

=head1 NAME

Game::Sudoku - blah blah blah

=head1 SYNOPSIS

  use Game::Sudoku;

=head1 DESCRIPTION

Game::Sudoku is ...

=head1 AUTHOR

Simon Proctor <simon.proctor@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2017 Simon Proctor

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
