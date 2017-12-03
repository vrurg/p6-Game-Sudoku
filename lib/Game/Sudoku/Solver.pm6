unit module Game::Sudoku::Solver;

use Game::Sudoku;

sub solve-puzzle( Game::Sudoku $game ) is export {

    my $initial = $game.Str;
    my $result = Game::Sudoku.new( :code($game.Str) );
    my $count;
    repeat {
	$count = [+] (^9 X ^9)
	.map( -> ($x,$y) { ($x,$y) => $result.possible($x,$y) } )
	.grep( *.value.elems == 1 )
	.map( -> $p { my ( $x, $y ) = $p.key; $result.set($x,$y,$p.value[0]); 1; } );
    } while ( $count > 0 && ! $result.complete );

    my @changes;
    for ^9 -> $idx {
	my $only = [(^)] $result.row($idx).map( -> ( $x,$y ) { $result.possible($x,$y) } );
	for $only.keys -> $val {
	    for $result.row($idx) -> ($x,$y) {
		if $val (elem) $result.possible($x,$y) {
		    @changes.push( ($x,$y) => $val );
		}
	    }
	}
	$only = [(^)] $result.col($idx).map( -> ( $x,$y ) { $result.possible($x,$y) } );
	for $only.keys -> $val {
	    for $result.col($idx) -> ($x,$y) {
		if $val (elem) $result.possible($x,$y) {
		    @changes.push( ($x,$y) => $val );
		}
	    }
	}
	$only = [(^)] $result.square($idx).map( -> ( $x,$y ) { $result.possible($x,$y) } );
	for $only.keys -> $val {
	    for $result.square($idx) -> ($x,$y) {
		if $val (elem) $result.possible($x,$y) {
		    @changes.push( ($x,$y) => $val );
		}
	    }
	}
    }
    for @changes -> $pair {
	my ( $x, $y ) = $pair.key;
	$result.set($x,$y,$pair.value[0]);
    }
    if ( ! $result.complete && $result.Str ne $initial ) {
	$result = solve-puzzle($result);
    }
    
    return $result;
}
