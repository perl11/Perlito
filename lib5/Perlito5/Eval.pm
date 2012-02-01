# Do not edit this file - Generated by Perlito5 8.0
use v5;
use utf8;
use strict;
use warnings;
no warnings ('redefine', 'once', 'void', 'uninitialized', 'misc', 'recursion');
use Perlito5::Perl5::Runtime;
our $MATCH = Perlito5::Match->new();
{
package main;
    sub new { shift; bless { @_ }, "main" }
    use v5;
    package CompUnit;
    sub eval {
        my $List__ = bless \@_, "ARRAY";
        ((my  $self) = $List__->[0]);
        ((my  $env) = $List__->[1]);
        ((my  $env1) = (do {
    (my  $List_a = bless [], 'ARRAY');
    (my  $List_v = bless [], 'ARRAY');
    push( @{$List_a}, (do {
    (my  $Hash_a = bless {}, 'HASH');
    $Hash_a
}) );
    ($List_v = ($env));
    for my $x ( @{(bless [0 .. ((scalar( @{$List_v} ) - 1))], 'ARRAY')} ) {
        push( @{$List_a}, $List_v->[$x] )
    };
    $List_a
}));
        for my $stmt ( @{($self->{('body')})} ) {
            $stmt->eval($env1)
        }
    };
    package Val::Int;
    sub eval {
        my $List__ = bless \@_, "ARRAY";
        ((my  $self) = $List__->[0]);
        ((my  $env) = $List__->[1]);
        (0 + $self->{('int')})
    };
    package Val::Num;
    sub eval {
        my $List__ = bless \@_, "ARRAY";
        ((my  $self) = $List__->[0]);
        ((my  $env) = $List__->[1]);
        (0 + $self->{('num')})
    };
    package Val::Buf;
    sub eval {
        my $List__ = bless \@_, "ARRAY";
        ((my  $self) = $List__->[0]);
        ((my  $env) = $List__->[1]);
        $self->{('buf')}
    };
    package Lit::Block;
    sub eval {
        my $List__ = bless \@_, "ARRAY";
        ((my  $self) = $List__->[0]);
        ((my  $env) = $List__->[1]);
        ((my  $env1) = (do {
    (my  $List_a = bless [], 'ARRAY');
    (my  $List_v = bless [], 'ARRAY');
    push( @{$List_a}, (do {
    (my  $Hash_a = bless {}, 'HASH');
    $Hash_a
}) );
    ($List_v = ($env));
    for my $x ( @{(bless [0 .. ((scalar( @{$List_v} ) - 1))], 'ARRAY')} ) {
        push( @{$List_a}, $List_v->[$x] )
    };
    $List_a
}));
        for my $stmt ( @{($self->{('stmts')})} ) {
            $stmt->eval($env1)
        }
    };
    package Lit::Array;
    sub eval {
        my $List__ = bless \@_, "ARRAY";
        ((my  $self) = $List__->[0]);
        ((my  $env) = $List__->[1]);
        (my  $List_a = bless [], 'ARRAY');
        for my $v ( @{($self->{('array1')})} ) {
            push( @{$List_a}, $v->eval($env) )
        };
        return ($List_a)
    };
    package Lit::Hash;
    sub eval {
        my $List__ = bless \@_, "ARRAY";
        ((my  $self) = $List__->[0]);
        ((my  $env) = $List__->[1]);
        (my  $Hash_h = bless {}, 'HASH');
        for my $field ( @{($self->{('hash1')})} ) {
            ((my  $pair) = $field->arguments());
            ($Hash_h->{($pair->[0])->eval($env)} = ($pair->[1])->eval($env))
        };
        return ($Hash_h)
    };
    package Index;
    sub eval {
        my $List__ = bless \@_, "ARRAY";
        ((my  $self) = $List__->[0]);
        ((my  $env) = $List__->[1]);
        ($self->{('obj')}->eval($env))->[$self->{('index_exp')}->eval($env)]
    };
    package Lookup;
    sub eval {
        my $List__ = bless \@_, "ARRAY";
        ((my  $self) = $List__->[0]);
        ((my  $env) = $List__->[1]);
        ($self->{('obj')}->eval($env))->{$self->{('index_exp')}->eval($env)}
    };
    package Var;
    sub eval {
        my $List__ = bless \@_, "ARRAY";
        ((my  $self) = $List__->[0]);
        ((my  $env) = $List__->[1]);
        ((my  $ns) = '');
        if (($self->{('namespace')})) {
            ($ns = ($self->{('namespace')} . '::'))
        }
        else {
            if (((($self->{('sigil')} eq chr(64))) && (($self->{('name')} eq 'ARGV')))) {
                return ((\@ARGV))
            }
        };
        ((my  $name) = ($self->{('sigil')} . $ns . $self->{('name')}));
        for my $e ( @{($env)} ) {
            if ((exists($e->{$name}))) {
                return ($e->{$name})
            }
        };
        warn(('Interpreter runtime error: variable ' . chr(39)), $name, (chr(39) . ' not found'))
    };
    sub plain_name {
        my $List__ = bless \@_, "ARRAY";
        ((my  $self) = $List__->[0]);
        if (($self->{('namespace')})) {
            return (($self->{('sigil')} . $self->{('namespace')} . '::' . $self->{('name')}))
        };
        return (($self->{('sigil')} . $self->{('name')}))
    };
    package Proto;
    sub eval {
        my $List__ = bless \@_, "ARRAY";
        ((my  $self) = $List__->[0]);
        ((my  $env) = $List__->[1]);
        ('' . $self->{('name')})
    };
    package Call;
    sub eval {
        my $List__ = bless \@_, "ARRAY";
        ((my  $self) = $List__->[0]);
        ((my  $env) = $List__->[1]);
        warn(('Interpreter TODO: Call'));
        ((my  $invocant) = $self->{('invocant')}->eval($env));
        if ((($invocant eq 'self'))) {
            ($invocant = chr(36) . 'self')
        };
        warn(('Interpreter runtime error: method ' . chr(39)), $self->{('method')}, ('()' . chr(39) . ' not found'))
    };
    package Apply;
    sub eval {
        my $List__ = bless \@_, "ARRAY";
        ((my  $self) = $List__->[0]);
        ((my  $env) = $List__->[1]);
        ((my  $ns) = '');
        if (($self->{('namespace')})) {
            ($ns = ($self->{('namespace')} . '::'))
        };
        ((my  $code) = ($ns . $self->{('code')}));
        for my $e ( @{($env)} ) {
            if ((exists($e->{$code}))) {
                return (($e->{$code}->($env, ($self->{('arguments')}))))
            }
        };
        warn(('Interpreter runtime error: subroutine ' . chr(39)), $code, ('()' . chr(39) . ' not found'))
    };
    package If;
    sub eval {
        my $List__ = bless \@_, "ARRAY";
        ((my  $self) = $List__->[0]);
        ((my  $env) = $List__->[1]);
        ((my  $cond) = $self->{('cond')});
        if (($cond->eval($env))) {
            ((my  $env1) = (do {
    (my  $List_a = bless [], 'ARRAY');
    (my  $List_v = bless [], 'ARRAY');
    push( @{$List_a}, (do {
    (my  $Hash_a = bless {}, 'HASH');
    $Hash_a
}) );
    ($List_v = ($env));
    for my $x ( @{(bless [0 .. ((scalar( @{$List_v} ) - 1))], 'ARRAY')} ) {
        push( @{$List_a}, $List_v->[$x] )
    };
    $List_a
}));
            for my $stmt ( @{(($self->{('body')})->stmts())} ) {
                $stmt->eval($env1)
            }
        }
        else {
            ((my  $env1) = (do {
    (my  $List_a = bless [], 'ARRAY');
    (my  $List_v = bless [], 'ARRAY');
    push( @{$List_a}, (do {
    (my  $Hash_a = bless {}, 'HASH');
    $Hash_a
}) );
    ($List_v = ($env));
    for my $x ( @{(bless [0 .. ((scalar( @{$List_v} ) - 1))], 'ARRAY')} ) {
        push( @{$List_a}, $List_v->[$x] )
    };
    $List_a
}));
            for my $stmt ( @{(($self->{('otherwise')})->stmts())} ) {
                $stmt->eval($env1)
            }
        };
        return (undef())
    };
    package For;
    sub eval {
        my $List__ = bless \@_, "ARRAY";
        ((my  $self) = $List__->[0]);
        ((my  $env) = $List__->[1]);
        ((my  $cond) = $self->{('cond')});
        ((my  $topic_name) = $self->{('body')}->sig()->plain_name());
        ((my  $env1) = (do {
    (my  $List_a = bless [], 'ARRAY');
    (my  $List_v = bless [], 'ARRAY');
    push( @{$List_a}, (do {
    (my  $Hash_a = bless {}, 'HASH');
    $Hash_a
}) );
    ($List_v = ($env));
    for my $x ( @{(bless [0 .. ((scalar( @{$List_v} ) - 1))], 'ARRAY')} ) {
        push( @{$List_a}, $List_v->[$x] )
    };
    $List_a
}));
        for my $topic ( @{($cond->eval($env))} ) {
            ($env1->[0] = (do {
    (my  $Hash_a = bless {}, 'HASH');
    ($Hash_a->{$topic_name} = $topic);
    $Hash_a
}));
            for my $stmt ( @{(($self->{('body')})->stmts())} ) {
                $stmt->eval($env1)
            }
        };
        return (undef())
    };
    package When;
    sub eval {
        my $List__ = bless \@_, "ARRAY";
        ((my  $self) = $List__->[0]);
        ((my  $env) = $List__->[1]);
        die(('TODO - When'))
    };
    package While;
    sub eval {
        my $List__ = bless \@_, "ARRAY";
        ((my  $self) = $List__->[0]);
        ((my  $env) = $List__->[1]);
        die(('TODO - While'))
    };
    package Decl;
    sub eval {
        my $List__ = bless \@_, "ARRAY";
        ((my  $self) = $List__->[0]);
        ((my  $env) = $List__->[1]);
        ((my  $decl) = $self->{('decl')});
        ((my  $name) = $self->{('var')}->plain_name());
        if ((!((exists(($env->[0])->{$name}))))) {
            (($env->[0])->{$name} = undef())
        };
        return (undef())
    };
    sub plain_name {
        my $List__ = bless \@_, "ARRAY";
        ((my  $self) = $List__->[0]);
        $self->{('var')}->plain_name()
    };
    package Sub;
    sub eval {
        my $List__ = bless \@_, "ARRAY";
        ((my  $self) = $List__->[0]);
        ((my  $env) = $List__->[1]);
        (my  $List_param_name = bless [], 'ARRAY');
        for my $field ( @{($self->{('sig')}->positional())} ) {
            push( @{$List_param_name}, $field->plain_name() )
        };
        ((my  $sub) = sub  {
    my $List__ = bless \@_, "ARRAY";
    my $env = $_[0];
    my $args = $_[1];
    (my  $Hash_context = bless {}, 'HASH');
    ((my  $n) = 0);
    ($Hash_context->{chr(64) . '_'} = $args);
    for my $name ( @{$List_param_name} ) {
        ($Hash_context->{$name} = ($args->[$n])->eval($env));
        ($n = ($n + 1))
    };
    ((my  $env1) = (do {
    (my  $List_a = bless [], 'ARRAY');
    (my  $List_v = bless [], 'ARRAY');
    push( @{$List_a}, $Hash_context );
    ($List_v = ($env));
    for my $x ( @{(bless [0 .. ((scalar( @{$List_v} ) - 1))], 'ARRAY')} ) {
        push( @{$List_a}, $List_v->[$x] )
    };
    $List_a
}));
    (my  $r);
    for my $stmt ( @{($self->{('block')})} ) {
        ($r = $stmt->eval($env1))
    };
    return ($r)
});
        if (($self->{('name')})) {
            (($env->[0])->{$self->{('name')}} = $sub)
        };
        return ($sub)
    };
    package Do;
    sub eval {
        my $List__ = bless \@_, "ARRAY";
        ((my  $self) = $List__->[0]);
        ((my  $env) = $List__->[1]);
        ((my  $env1) = (do {
    (my  $List_a = bless [], 'ARRAY');
    (my  $List_v = bless [], 'ARRAY');
    push( @{$List_a}, (do {
    (my  $Hash_a = bless {}, 'HASH');
    $Hash_a
}) );
    ($List_v = ($env));
    for my $x ( @{(bless [0 .. ((scalar( @{$List_v} ) - 1))], 'ARRAY')} ) {
        push( @{$List_a}, $List_v->[$x] )
    };
    $List_a
}));
        for my $stmt ( @{($self->{('block')})} ) {
            $stmt->eval($env1)
        }
    };
    package Use;
    sub eval {
        my $List__ = bless \@_, "ARRAY";
        ((my  $self) = $List__->[0]);
        ((my  $env) = $List__->[1]);
        warn(('Interpreter TODO: Use'));
        ('use ' . $self->{('mod')})
    }
}

1;
