package Perlito5;

use strict;
use warnings;

use Perlito5::Match;
use Perlito5::Grammar;
use Perlito5::Grammar::Control;
use Perlito5::Grammar::Precedence;
use Perlito5::Grammar::Expression;
use Perlito5::Macro;
use Perlito5::Runtime;

use Perlito5::Perl6::Emitter;
use Perlito5::Perl6::PrettyPrinter;

sub compile_p5_to_p6 {
    my $s = shift;
    $Perlito5::PKG_NAME = 'main';
    $Perlito5::PROTO    = {};
    my $ast = Perlito5::Grammar->exp_stmts($s, 0);
    my @data = Perlito5::AST::CompUnit::emit_perl6_program(
        [
            Perlito5::AST::CompUnit->new( name => 'main', body => Perlito5::Match::flat($ast) )
        ]
    );
    my $out = [];
    Perlito5::Perl6::PrettyPrinter::pretty_print( \@data, 0, $out );
    return join( '', "use v6;\n", 
                     @$out, "\n",
               );

}

1;

