use v6.c;

class Game::Sudoku:ver<0.0.1>:auth<simon.proctor@gmail.com> {

    subset GridCode of Str where *.chars == 81;
    subset Idx of Int where 0 <= * <= 8;
    
    has @!grid; 
    has @!validations;
    
    multi submethod BUILD( GridCode :$code = ("0" x 81) ) {
        my @tmp = $code.comb;
        for ^9 -> $y {
            for ^9 -> $x {
                @!grid[$y][$x] = @tmp[($y*9)+$x]; 
            }
        }
        for ^9 -> $c {
            @!validations.push( ( none( self!row( $c ).map( -> %t { @!grid[%t<y>][%t<x>] } ) ),
                                  one( self!row( $c ).map( -> %t { @!grid[%t<y>][%t<x>] } ) ) ) );
            @!validations.push( ( none( self!col( $c ).map( -> %t { @!grid[%t<y>][%t<x>] } ) ),
                                  one( self!col( $c ).map( -> %t { @!grid[%t<y>][%t<x>] } ) ) ) );
            @!validations.push( ( none( self!sqr( $c ).map( -> %t { @!grid[%t<y>][%t<x>] } ) ),
                                  one( self!sqr( $c ).map( -> %t { @!grid[%t<y>][%t<x>] } ) ) ) );
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

    method valid {
        [&&] @!validations.map(
            -> ( $none, $one ) {
                [&&] (1..9).map(
                    -> $val {
                        ( ?( $none == $val ) ^^ ?( $one == $val ) );
                    }
                )
            }
        );
    }
    method complete { False; }

    method !row( Idx $y ) {
        return (^9).map( { my %t = ( x => $_, y => $y ); %t; } );
    }

    method !col( Idx $x ) {
        return (^9).map( { my %t = ( x => $x, y => $_ ); %t } );
    }

    method !sqr( Idx $sq ) {
        my $x = $sq % 3 * 3;
        my $y = $sq div 3 * 3;
        my $tx = $x div 3 * 3;
        my $ty = $y div 3 * 3;
        return ( (0,1,2) X (0,1,2) ).map( -> ( $dx, $dy ) { my %t = ( x => $tx + $dx, y => $ty + $dy ); %t } );
    }
        
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
