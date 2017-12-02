use v6.c;

class Game::Sudoku:ver<0.0.1>:auth<simon.proctor@gmail.com> {

    subset GridCode of Str where *.chars == 81;
    subset Idx of Int where 0 <= * <= 8;
    subset CellValue of Int where 1 <= * <= 9;
    
    has @!grid; 
    has $!valid-all;
    has $!complete-all;
    
    multi submethod BUILD( GridCode :$code = ("0" x 81) ) {
        my @tmp = $code.comb.map( *.Int );
        (^9 X ^9).map( -> ($x,$y) { @!grid[$y][$x] = @tmp[($y*9)+$x] } );

        my @all;
        my @valid;
        for ^9 -> $c {
            @valid.push( one( none( self.row( $c ).map( -> ( $x, $y ) { @!grid[$y][$x] } ) ),
                              one( self.row( $c ).map( -> ( $x, $y ) { @!grid[$y][$x] } ) ) ) )
            .push( one( none( self.col( $c ).map( -> ( $x, $y ) { @!grid[$y][$x] } ) ),
                              one( self.col( $c ).map( -> ( $x, $y ) { @!grid[$y][$x] } ) ) ) )
            .push( one( none( self.square( $c ).map( -> ( $x, $y ) { @!grid[$y][$x] } ) ),
                              one( self.square( $c ).map( -> ( $x, $y ) { @!grid[$y][$x] } ) ) ) );
            @all.push(
                one( self.row( $c ).map( -> ( $x, $y ) { @!grid[$y][$x] } ) ),
                one( self.col( $c ).map( -> ( $x, $y ) { @!grid[$y][$x] } ) ),
                one( self.square( $c ).map( -> ( $x, $y ) { @!grid[$y][$x] } ) )
            );
        }
        $!complete-all = all( @all );
        $!valid-all = all( @valid );
    }
    
    multi method Str {
        return @!grid.map( -> @row { @row.join() } ).join();
    }
    
    multi method gist {
        my @lines;
        for ^9 -> $y {
            my @row;
            for ^9 -> $x {
                @row.push( @!grid[$y][$x] > 0 ?? @!grid[$y][$x] !! ' ' );
                @row.push( "|" ) if $x == 2|5;
            }
            @lines.push( @row.join() );
            @lines.push( "---+---+---" ) if $y == 2|5;
        }
        return @lines.join( "\n" );
    }

    method valid {
        [&&] (1..9).map( so $!valid-all == * );
    }
    
    method complete {
        [&&] (1..9).map( so $!complete-all == *  );
    }

    method full {
	[&&] @!grid.map( { [&&] $_.map( { $_ != 0 } ) } )
    }

    method row( Idx $y ) {
        return (^9).map( { ( $_, $y ) } );
    }

    method col( Idx $x ) {
        return (^9).map( { ( $x, $_ ) } );
    }

    multi method square( Idx $sq ) {
        my $x = $sq % 3 * 3;
        my $y = $sq div 3 * 3;
        return self.square( $x, $y );
    }

    multi method square( Idx $x, Idx $y ) {
        my $tx = $x div 3 * 3;
        my $ty = $y div 3 * 3;
        return ( (0,1,2) X (0,1,2) ).map( -> ( $dx, $dy ) { ( $tx + $dx, $ty + $dy ) } );
    }

    method possible( Idx $x, Idx $y ) {
	return () if @!grid[$y][$x] > 0;

        my $current = [(|)]
	    ( self.row($y).map( -> ( $x, $y ) { @!grid[$y][$x] } ).grep( * > 0 ) ),
	    ( self.col($x).map( -> ( $x, $y ) { @!grid[$y][$x] } ).grep( * > 0 ) ),
	    ( self.square($x,$y).map( -> ( $x, $y ) { @!grid[$y][$x] } ).grep( * > 0 ) );
        
	( (1..9) (^) $current ).keys.sort;
    }

    method set( Idx $x, Idx $y, CellValue $val ) {
	@!grid[$y][$x] = $val;
	return self;
    }
}

=begin pod

=head1 NAME

Game::Sudoku - Store, validate and solve sudoku puzzles

=head1 SYNOPSIS

    use Game::Sudoku;

    # Create an empty game
    my $game = Game::Sudoku.new();

=head1 DESCRIPTION

Game::Sudoku is a simple library to store, test and attempt to solve sudoku puzzles.

=head1 AUTHOR

Simon Proctor <simon.proctor@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2017 Simon Proctor

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
