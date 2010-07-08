# Do not edit this file - Generated by MiniPerl6 4.1
use v5;
use strict;
use MiniPerl6::Perl5::Runtime;
our $MATCH = MiniPerl6::Match->new();
{
package Python;
sub new { shift; bless { @_ }, "Python" }
sub tab { my $level = $_[0]; ('    ' x $level) }
}

{
package MiniPerl6::Python::LexicalBlock;
sub new { shift; bless { @_ }, "MiniPerl6::Python::LexicalBlock" }
sub block { $_[0]->{block} };
sub needs_return { $_[0]->{needs_return} };
sub top_level { $_[0]->{top_level} };
my  $ident;
my  $List_anon_block;
sub push_stmt_python { my $block = $_[0]; push( @{$List_anon_block}, $block ) };
sub get_ident_python { ($ident = ($ident + 1)); return($ident) };
sub has_my_decl { my $self = $_[0]; for my $decl ( @{$self->{block}} ) { if ((Main::isa($decl, 'Decl') && ($decl->decl() eq 'my'))) { return(1) } else {  };if ((Main::isa($decl, 'Bind') && (Main::isa($decl->parameters(), 'Decl') && ($decl->parameters()->decl() eq 'my')))) { return(1) } else {  } }; return(0) };
sub emit_python { my $self = $_[0]; $self->emit_python_indented(0) };
sub emit_python_indented { my $self = $_[0]; my $level = $_[1]; if (@{$self->{block}}) {  } else { push( @{$self->{block}}, Val::Undef->new(  ) ) }; my  $List_s; my  $List_tmp; for my $stmt ( @{$List_anon_block} ) { push( @{$List_tmp}, $stmt ) }; (my  $has_decl = []); (my  $block = []); for my $decl ( @{$self->{block}} ) { if ((Main::isa($decl, 'Decl') && ($decl->decl() eq 'has'))) { push( @{$has_decl}, $decl ) } else { if ((Main::isa($decl, 'Bind') && (Main::isa($decl->parameters(), 'Decl') && ($decl->parameters()->decl() eq 'has')))) { push( @{$has_decl}, $decl ) } else { push( @{@{$block}}, $decl ) } } }; if (@{$has_decl}) { my  $List_decl;(my  $self_var = Var->new( 'name' => 'self','sigil' => '$','twigil' => '', ));for my $decl ( @{$has_decl} ) { if ((Main::isa($decl, 'Decl') && ($decl->decl() eq 'has'))) { push( @{$List_decl}, Bind->new( 'parameters' => Call->new( 'arguments' => [],'hyper' => '','invocant' => Proto->new( 'name' => 'self', ),'method' => 'xyz', ),'arguments' => Val::Int->new( 'int' => 0, ), ) ) } else {  };if ((Main::isa($decl, 'Bind') && (Main::isa($decl->parameters(), 'Decl') && ($decl->parameters()->decl() eq 'has')))) { push( @{$List_decl}, $decl->parameters() ) } else {  } };push( @{$List_decl}, $self_var );push( @{$List_s}, Method->new( 'name' => '__init__','block' => $List_decl,'sig' => Sig->new( 'invocant' => $self_var,'named' => {  },'positional' => [], ), )->emit_python_indented($level) ) } else {  }; for my $decl ( @{$block} ) { if ((Main::isa($decl, 'Decl') && ($decl->decl() eq 'my'))) { push( @{$List_s}, $decl->emit_python_init($level) ) } else {  };if ((Main::isa($decl, 'Bind') && (Main::isa($decl->parameters(), 'Decl') && ($decl->parameters()->decl() eq 'my')))) { push( @{$List_s}, $decl->parameters()->emit_python_init($level) ) } else {  } }; my  $last_statement; if ($self->{needs_return}) { ($last_statement = pop( @{@{$block}} )) } else {  }; for my $stmt ( @{$block} ) { ($List_anon_block = []);(my  $s2 = $stmt->emit_python_indented($level));for my $stmt ( @{$List_anon_block} ) { push( @{$List_s}, $stmt->emit_python_indented($level) ) };push( @{$List_s}, $s2 ) }; if (($self->{needs_return} && $last_statement)) { ($List_anon_block = []);my  $s2;if (Main::isa($last_statement, 'If')) { (my  $cond = $last_statement->cond());(my  $has_otherwise = ($last_statement->otherwise() ? 1 : 0));(my  $body_block = MiniPerl6::Python::LexicalBlock->new( 'block' => $last_statement->body(),'needs_return' => 1, ));(my  $otherwise_block = MiniPerl6::Python::LexicalBlock->new( 'block' => $last_statement->otherwise(),'needs_return' => 1, ));if ($body_block->has_my_decl()) { ($body_block = Return->new( 'result' => Do->new( 'block' => $last_statement->body(), ), )) } else {  };if (($has_otherwise && $otherwise_block->has_my_decl())) { ($otherwise_block = Return->new( 'result' => Do->new( 'block' => $last_statement->otherwise(), ), )) } else {  };($s2 = Python::tab($level) . 'if ' . $cond->emit_python() . ':
' . $body_block->emit_python_indented(($level + 1)));if ($has_otherwise) { ($s2 = $s2 . '
' . Python::tab($level) . 'else:
' . $otherwise_block->emit_python_indented(($level + 1))) } else {  } } else { if ((Main::isa($last_statement, 'Return') || Main::isa($last_statement, 'For'))) { ($s2 = $last_statement->emit_python_indented($level)) } else { ($s2 = Python::tab($level) . 'return ' . $last_statement->emit_python()) } };for my $stmt ( @{$List_anon_block} ) { push( @{$List_s}, $stmt->emit_python_indented($level) ) };push( @{$List_s}, $s2 ) } else {  }; ($List_anon_block = $List_tmp); return(Main::join($List_s, '
')) }
}

{
package CompUnit;
sub new { shift; bless { @_ }, "CompUnit" }
sub name { $_[0]->{name} };
sub attributes { $_[0]->{attributes} };
sub methods { $_[0]->{methods} };
sub body { $_[0]->{body} };
sub emit_python { my $self = $_[0]; $self->emit_python_indented(0) };
sub emit_python_indented { my $self = $_[0]; my $level = $_[1]; (my  $block = MiniPerl6::Python::LexicalBlock->new( 'block' => $self->{body}, )); Python::tab($level) . 'class ' . $self->{name} . ':
' . $block->emit_python_indented(($level + 1)) . '
' }
}

{
package Val::Int;
sub new { shift; bless { @_ }, "Val::Int" }
sub int { $_[0]->{int} };
sub emit_python { my $self = $_[0]; $self->{int} };
sub emit_python_indented { my $self = $_[0]; my $level = $_[1]; Python::tab($level) . $self->{int} }
}

{
package Val::Bit;
sub new { shift; bless { @_ }, "Val::Bit" }
sub bit { $_[0]->{bit} };
sub emit_python { my $self = $_[0]; $self->{bit} };
sub emit_python_indented { my $self = $_[0]; my $level = $_[1]; Python::tab($level) . $self->{bit} }
}

{
package Val::Num;
sub new { shift; bless { @_ }, "Val::Num" }
sub num { $_[0]->{num} };
sub emit_python { my $self = $_[0]; $self->{num} };
sub emit_python_indented { my $self = $_[0]; my $level = $_[1]; Python::tab($level) . $self->{num} }
}

{
package Val::Buf;
sub new { shift; bless { @_ }, "Val::Buf" }
sub buf { $_[0]->{buf} };
sub emit_python { my $self = $_[0]; $self->emit_python_indented(0) };
sub emit_python_indented { my $self = $_[0]; my $level = $_[1]; Python::tab($level) . '"""' . $self->{buf} . '"""' }
}

{
package Val::Undef;
sub new { shift; bless { @_ }, "Val::Undef" }
sub emit_python { my $self = $_[0]; $self->emit_python_indented(0) };
sub emit_python_indented { my $self = $_[0]; my $level = $_[1]; Python::tab($level) . 'mp6_Undef()' }
}

{
package Val::Object;
sub new { shift; bless { @_ }, "Val::Object" }
sub class { $_[0]->{class} };
sub fields { $_[0]->{fields} };
sub emit_python { my $self = $_[0]; $self->emit_python_indented(0) };
sub emit_python_indented { my $self = $_[0]; my $level = $_[1]; Python::tab($level) . Main::perl($self->{class}, ) . '(' . Main::perl($self->{fields}, ) . ')' }
}

{
package Lit::Array;
sub new { shift; bless { @_ }, "Lit::Array" }
sub array1 { $_[0]->{array1} };
sub emit_python { my $self = $_[0]; $self->emit_python_indented(0) };
sub emit_python_indented { my $self = $_[0]; my $level = $_[1]; (my  $needs_interpolation = 0); for my $item ( @{$self->{array1}} ) { if (((Main::isa($item, 'Var') && ($item->sigil() eq '@')) || (Main::isa($item, 'Apply') && ($item->code() eq 'prefix:<@>')))) { ($needs_interpolation = 1) } else {  } }; if ($needs_interpolation) { my  $List_block;(my  $temp_array = Var->new( 'name' => 'a','namespace' => '','sigil' => '@','twigil' => '', ));(my  $input_array = Var->new( 'name' => 'b','namespace' => '','sigil' => '@','twigil' => '', ));push( @{$List_block}, Decl->new( 'decl' => 'my','type' => '','var' => $temp_array, ) );(my  $index = 0);for my $item ( @{$self->{array1}} ) { if (((Main::isa($item, 'Var') && ($item->sigil() eq '@')) || (Main::isa($item, 'Apply') && ($item->code() eq 'prefix:<@>')))) { push( @{$List_block}, Call->new( 'method' => 'extend','arguments' => [Index->new( 'obj' => $input_array,'index_exp' => Val::Int->new( 'int' => $index, ), )],'hyper' => '','invocant' => $temp_array, ) ) } else { push( @{$List_block}, Call->new( 'method' => 'push','arguments' => [Index->new( 'obj' => $input_array,'index_exp' => Val::Int->new( 'int' => $index, ), )],'hyper' => '','invocant' => $temp_array, ) ) };($index = ($index + 1)) };push( @{$List_block}, $temp_array );(my  $label = '_anon_' . MiniPerl6::Python::LexicalBlock::get_ident_python());MiniPerl6::Python::LexicalBlock::push_stmt_python(Sub->new( 'name' => $label,'block' => $List_block,'sig' => Sig->new( 'invocant' => (undef),'positional' => [$input_array],'named' => {  }, ), ));return(Python::tab($level) . $label . '(mp6_Array([' . Main::join([ map { $_->emit_python() } @{ $self->{array1} } ], ', ') . ']))') } else { Python::tab($level) . 'mp6_Array([' . Main::join([ map { $_->emit_python() } @{ $self->{array1} } ], ', ') . '])' } }
}

{
package Lit::Hash;
sub new { shift; bless { @_ }, "Lit::Hash" }
sub hash1 { $_[0]->{hash1} };
sub emit_python { my $self = $_[0]; $self->emit_python_indented(0) };
sub emit_python_indented { my $self = $_[0]; my $level = $_[1]; (my  $fields = $self->{hash1}); my  $List_dict; for my $field ( @{$fields} ) { push( @{$List_dict}, $field->[0]->emit_python() . ':' . $field->[1]->emit_python() ) }; Python::tab($level) . '{' . Main::join($List_dict, ', ') . '}' }
}

{
package Lit::Code;
sub new { shift; bless { @_ }, "Lit::Code" }
1
}

{
package Lit::Object;
sub new { shift; bless { @_ }, "Lit::Object" }
sub class { $_[0]->{class} };
sub fields { $_[0]->{fields} };
sub emit_python { my $self = $_[0]; $self->emit_python_indented(0) };
sub emit_python_indented { my $self = $_[0]; my $level = $_[1]; (my  $fields = $self->{fields}); (my  $str = ''); for my $field ( @{$fields} ) { ($str = $str . $field->[0]->emit_python() . ' = ' . $field->[1]->emit_python() . ',') }; Python::tab($level) . $self->{class} . '( ' . $str . ' )' }
}

{
package Index;
sub new { shift; bless { @_ }, "Index" }
sub obj { $_[0]->{obj} };
sub index_exp { $_[0]->{index_exp} };
sub emit_python { my $self = $_[0]; $self->emit_python_indented(0) };
sub emit_python_indented { my $self = $_[0]; my $level = $_[1]; Python::tab($level) . $self->{obj}->emit_python() . '.index(' . $self->{index_exp}->emit_python() . ')' }
}

{
package Lookup;
sub new { shift; bless { @_ }, "Lookup" }
sub obj { $_[0]->{obj} };
sub index_exp { $_[0]->{index_exp} };
sub emit_python { my $self = $_[0]; $self->emit_python_indented(0) };
sub emit_python_indented { my $self = $_[0]; my $level = $_[1]; Python::tab($level) . $self->{obj}->emit_python() . '[' . $self->{index_exp}->emit_python() . ']' }
}

{
package Var;
sub new { shift; bless { @_ }, "Var" }
sub sigil { $_[0]->{sigil} };
sub twigil { $_[0]->{twigil} };
sub name { $_[0]->{name} };
sub emit_python { my $self = $_[0]; $self->emit_python_indented(0) };
sub emit_python_indented { my $self = $_[0]; my $level = $_[1]; (my  $table = { '$' => '','@' => 'List_','%' => 'Hash_','&' => 'Code_', }); return(Python::tab($level) . (($self->{twigil} eq '.') ? 'self.' . $self->{name} : (($self->{name} eq '/') ? $table->{$self->{sigil}} . 'MATCH' : $table->{$self->{sigil}} . $self->{name}))) };
sub name { my $self = $_[0]; $self->{name} }
}

{
package Bind;
sub new { shift; bless { @_ }, "Bind" }
sub parameters { $_[0]->{parameters} };
sub arguments { $_[0]->{arguments} };
sub emit_python { my $self = $_[0]; $self->emit_python_indented(0) };
sub emit_python_indented { my $self = $_[0]; my $level = $_[1]; if (Main::isa($self->{parameters}, 'Index')) { return(Python::tab($level) . $self->{parameters}->obj()->emit_python() . '.set(' . $self->{parameters}->index_exp()->emit_python() . ', ' . $self->{arguments}->emit_python() . ')') } else {  }; Python::tab($level) . $self->{parameters}->emit_python() . ' = ' . $self->{arguments}->emit_python() }
}

{
package Proto;
sub new { shift; bless { @_ }, "Proto" }
sub name { $_[0]->{name} };
sub emit_python { my $self = $_[0]; $self->emit_python_indented(0) };
sub emit_python_indented { my $self = $_[0]; my $level = $_[1]; Python::tab($level) . $self->{name} }
}

{
package Call;
sub new { shift; bless { @_ }, "Call" }
sub invocant { $_[0]->{invocant} };
sub hyper { $_[0]->{hyper} };
sub method { $_[0]->{method} };
sub arguments { $_[0]->{arguments} };
sub emit_python { my $self = $_[0]; $self->emit_python_indented(0) };
sub emit_python_indented { my $self = $_[0]; my $level = $_[1]; (my  $invocant = $self->{invocant}->emit_python()); if (($self->{method} eq 'new')) {  } else {  }; if ((($self->{method} eq 'perl') || (($self->{method} eq 'yaml') || (($self->{method} eq 'say') || (($self->{method} eq 'join') || (($self->{method} eq 'chars') || ($self->{method} eq 'isa'))))))) { if ($self->{hyper}) { return('map(lambda: Main.' . $self->{method} . '( self, ' . Main::join([ map { $_->emit_python() } @{ $self->{arguments} } ], ', ') . ') , ' . $invocant . ')
') } else { return('Main.' . $self->{method} . '(' . $invocant . ', ' . Main::join([ map { $_->emit_python() } @{ $self->{arguments} } ], ', ') . ')') } } else {  }; (my  $meth = $self->{method}); if (($meth eq 'postcircumfix:<( )>')) { return(Python::tab($level) . $invocant . '(' . Main::join([ map { $_->emit_python() } @{ $self->{arguments} } ], ', ') . ')') } else {  }; (my  $call = '.' . $meth . '(' . Main::join([ map { $_->emit_python() } @{ $self->{arguments} } ], ', ') . ')'); if ($self->{hyper}) { Python::tab($level) . '[ map { $_' . $call . ' } @{ ' . $invocant . ' } ]' } else { Python::tab($level) . $invocant . $call } }
}

{
package Apply;
sub new { shift; bless { @_ }, "Apply" }
sub code { $_[0]->{code} };
sub arguments { $_[0]->{arguments} };
sub emit_python_indented { my $self = $_[0]; my $level = $_[1]; Python::tab($level) . $self->emit_python() };
sub emit_python { my $self = $_[0]; (my  $code = $self->{code}); if (Main::isa($code, 'Str')) {  } else { return('(' . $self->{code}->emit_python() . ').(' . Main::join([ map { $_->emit_python() } @{ $self->{arguments} } ], ', ') . ')') }; if (($code eq 'self')) { return('self') } else {  }; if (($code eq 'say')) { return('mp6_say(' . Main::join([ map { $_->emit_python() } @{ $self->{arguments} } ], ', ') . ')') } else {  }; if (($code eq 'print')) { return('mp6_print(' . Main::join([ map { $_->emit_python() } @{ $self->{arguments} } ], ', ') . ')') } else {  }; if (($code eq 'warn')) { return('mp6_warn(' . Main::join([ map { $_->emit_python() } @{ $self->{arguments} } ], ', ') . ')') } else {  }; if (($code eq 'array')) { return('[' . Main::join([ map { $_->emit_python() } @{ $self->{arguments} } ], ' ') . ']') } else {  }; if (($code eq 'prefix:<~>')) { return('("" . ' . Main::join([ map { $_->emit_python() } @{ $self->{arguments} } ], ' ') . ')') } else {  }; if (($code eq 'prefix:<!>')) { return('not (' . Main::join([ map { $_->emit_python() } @{ $self->{arguments} } ], ' ') . ')') } else {  }; if (($code eq 'prefix:<?>')) { return('not (not (' . Main::join([ map { $_->emit_python() } @{ $self->{arguments} } ], ' ') . '))') } else {  }; if (($code eq 'prefix:<$>')) { return('${' . Main::join([ map { $_->emit_python() } @{ $self->{arguments} } ], ' ') . '}') } else {  }; if (($code eq 'prefix:<@>')) { return('@{' . Main::join([ map { $_->emit_python() } @{ $self->{arguments} } ], ' ') . '}') } else {  }; if (($code eq 'prefix:<%>')) { return('%{' . Main::join([ map { $_->emit_python() } @{ $self->{arguments} } ], ' ') . '}') } else {  }; if (($code eq 'infix:<~>')) { return('(str(' . Main::join([ map { $_->emit_python() } @{ $self->{arguments} } ], ') + str(') . '))') } else {  }; if (($code eq 'infix:<+>')) { return('(mp6_to_num(' . Main::join([ map { $_->emit_python() } @{ $self->{arguments} } ], ') + mp6_to_num(') . '))') } else {  }; if (($code eq 'infix:<->')) { return('(' . Main::join([ map { $_->emit_python() } @{ $self->{arguments} } ], ' - ') . ')') } else {  }; if (($code eq 'infix:<*>')) { return('(' . Main::join([ map { $_->emit_python() } @{ $self->{arguments} } ], ' * ') . ')') } else {  }; if (($code eq 'infix:</>')) { return('(' . Main::join([ map { $_->emit_python() } @{ $self->{arguments} } ], ' / ') . ')') } else {  }; if (($code eq 'infix:<&&>')) { return('(' . Main::join([ map { $_->emit_python() } @{ $self->{arguments} } ], ' and ') . ')') } else {  }; if (($code eq 'infix:<||>')) { return('(' . Main::join([ map { $_->emit_python() } @{ $self->{arguments} } ], ' or ') . ')') } else {  }; if (($code eq 'infix:<eq>')) { return('(str(' . Main::join([ map { $_->emit_python() } @{ $self->{arguments} } ], ') == str(') . '))') } else {  }; if (($code eq 'infix:<ne>')) { return('(str(' . Main::join([ map { $_->emit_python() } @{ $self->{arguments} } ], ') != str(') . '))') } else {  }; if (($code eq 'infix:<==>')) { return('(mp6_to_num(' . Main::join([ map { $_->emit_python() } @{ $self->{arguments} } ], ') == mp6_to_num(') . '))') } else {  }; if (($code eq 'infix:<!=>')) { return('(mp6_to_num(' . Main::join([ map { $_->emit_python() } @{ $self->{arguments} } ], ') != mp6_to_num(') . '))') } else {  }; if (($code eq 'infix:<<>')) { return('(mp6_to_num(' . Main::join([ map { $_->emit_python() } @{ $self->{arguments} } ], ') < mp6_to_num(') . '))') } else {  }; if (($code eq 'infix:<>>')) { return('(mp6_to_num(' . Main::join([ map { $_->emit_python() } @{ $self->{arguments} } ], ') > mp6_to_num(') . '))') } else {  }; if (($code eq 'ternary:<?? !!>')) { (my  $ast = Do->new( 'block' => [If->new( 'cond' => $self->{arguments}->[0],'body' => [$self->{arguments}->[1]],'otherwise' => [$self->{arguments}->[2]], )], ));return($ast->emit_python()) } else {  }; if (($code eq 'substr')) { return($self->{arguments}->[0]->emit_python() . '[' . $self->{arguments}->[1]->emit_python() . ':' . $self->{arguments}->[1]->emit_python() . ' + ' . $self->{arguments}->[2]->emit_python() . ']') } else {  }; if (($code eq 'index')) { return($self->{arguments}->[0]->emit_python() . '.index(' . $self->{arguments}->[1]->emit_python() . ')') } else {  }; if (($code eq 'shift')) { return($self->{arguments}->[0]->emit_python() . '.shift()') } else {  }; $self->{code} . '(' . Main::join([ map { $_->emit_python() } @{ $self->{arguments} } ], ', ') . ')' };
sub emit_python_indented { my $self = $_[0]; my $level = $_[1]; Python::tab($level) . $self->emit_python() }
}

{
package Return;
sub new { shift; bless { @_ }, "Return" }
sub result { $_[0]->{result} };
sub emit_python { my $self = $_[0]; $self->emit_python_indented(0) };
sub emit_python_indented { my $self = $_[0]; my $level = $_[1]; Python::tab($level) . 'return ' . $self->{result}->emit_python() }
}

{
package If;
sub new { shift; bless { @_ }, "If" }
sub cond { $_[0]->{cond} };
sub body { $_[0]->{body} };
sub otherwise { $_[0]->{otherwise} };
sub emit_python { my $self = $_[0]; $self->emit_python_indented(0) };
sub emit_python_indented { my $self = $_[0]; my $level = $_[1]; (my  $has_body = (@{$self->{body}} ? 1 : 0)); (my  $has_otherwise = (@{$self->{otherwise}} ? 1 : 0)); (my  $body_block = MiniPerl6::Python::LexicalBlock->new( 'block' => $self->{body}, )); (my  $otherwise_block = MiniPerl6::Python::LexicalBlock->new( 'block' => $self->{otherwise}, )); if ($body_block->has_my_decl()) { ($body_block = Do->new( 'block' => $self->{body}, )) } else {  }; if (($has_otherwise && $otherwise_block->has_my_decl())) { ($otherwise_block = Do->new( 'block' => $self->{otherwise}, )) } else {  }; (my  $s = Python::tab($level) . 'if ' . $self->{cond}->emit_python() . ':
' . $body_block->emit_python_indented(($level + 1))); if ($has_otherwise) { ($s = $s . '
' . Python::tab($level) . 'else:
' . $otherwise_block->emit_python_indented(($level + 1))) } else {  }; return($s) }
}

{
package While;
sub new { shift; bless { @_ }, "While" }
sub init { $_[0]->{init} };
sub cond { $_[0]->{cond} };
sub continue { $_[0]->{continue} };
sub body { $_[0]->{body} };
sub emit_python { my $self = $_[0]; $self->emit_python_indented(0) };
sub emit_python_indented { my $self = $_[0]; my $level = $_[1]; (my  $body_block = MiniPerl6::Python::LexicalBlock->new( 'block' => $self->{body}, )); if ($body_block->has_my_decl()) { ($body_block = Do->new( 'block' => $self->{body}, )) } else {  }; if (($self->{init} && $self->{continue})) { die('not implemented (While)') } else {  }; Python::tab($level) . 'while ' . $self->{cond}->emit_python() . ':
' . $body_block->emit_python_indented(($level + 1)) }
}

{
package For;
sub new { shift; bless { @_ }, "For" }
sub cond { $_[0]->{cond} };
sub body { $_[0]->{body} };
sub topic { $_[0]->{topic} };
sub emit_python { my $self = $_[0]; $self->emit_python_indented(0) };
sub emit_python_indented { my $self = $_[0]; my $level = $_[1]; (my  $body_block = MiniPerl6::Python::LexicalBlock->new( 'block' => $self->{body}, )); if ($body_block->has_my_decl()) { ($body_block = Do->new( 'block' => $self->{body}, )) } else {  }; Python::tab($level) . 'for ' . $self->{topic}->emit_python() . ' in ' . $self->{cond}->emit_python() . ':
' . $body_block->emit_python_indented(($level + 1)) }
}

{
package Decl;
sub new { shift; bless { @_ }, "Decl" }
sub decl { $_[0]->{decl} };
sub type { $_[0]->{type} };
sub var { $_[0]->{var} };
sub emit_python { my $self = $_[0]; $self->emit_python_indented(0) };
sub emit_python_indented { my $self = $_[0]; my $level = $_[1]; (my  $decl = $self->{decl}); (my  $name = $self->{var}->name()); Python::tab($level) . (($decl eq 'has') ? '' : $self->{var}->emit_python()) };
sub emit_python_init { my $self = $_[0]; my $level = $_[1]; if (($self->{decl} eq 'my')) { (my  $str = Python::tab($level) . $self->{var}->emit_python() . ' = ');if (($self->{var}->sigil() eq '%')) { ($str = $str . '{}') } else { if (($self->{var}->sigil() eq '@')) { ($str = $str . 'mp6_Array([])') } else { ($str = $str . 'mp6_Undef()') } };return($str) } else { die('not implemented: Decl \'' . $self->{decl} . '\'') } }
}

{
package Sig;
sub new { shift; bless { @_ }, "Sig" }
sub invocant { $_[0]->{invocant} };
sub positional { $_[0]->{positional} };
sub named { $_[0]->{named} };
sub emit_python { my $self = $_[0]; ' print \'Signature - TODO\'; die \'Signature - TODO\'; ' };
sub invocant { my $self = $_[0]; $self->{invocant} };
sub positional { my $self = $_[0]; $self->{positional} }
}

{
package Method;
sub new { shift; bless { @_ }, "Method" }
sub name { $_[0]->{name} };
sub sig { $_[0]->{sig} };
sub block { $_[0]->{block} };
sub emit_python { my $self = $_[0]; $self->emit_python_indented(0) };
sub emit_python_indented { my $self = $_[0]; my $level = $_[1]; (my  $sig = $self->{sig}); (my  $invocant = $sig->invocant()); (my  $pos = $sig->positional()); my  $List_args; push( @{$List_args}, $invocant->emit_python() ); for my $field ( @{$pos} ) { push( @{$List_args}, $field->emit_python() ) }; (my  $block = MiniPerl6::Python::LexicalBlock->new( 'block' => $self->{block},'needs_return' => 1, )); Python::tab($level) . 'def ' . $self->{name} . '(' . Main::join($List_args, ', ') . '):
' . $block->emit_python_indented(($level + 1)) }
}

{
package Sub;
sub new { shift; bless { @_ }, "Sub" }
sub name { $_[0]->{name} };
sub sig { $_[0]->{sig} };
sub block { $_[0]->{block} };
sub emit_python { my $self = $_[0]; $self->emit_python_indented(0) };
sub emit_python_indented { my $self = $_[0]; my $level = $_[1]; if (($self->{name} eq '')) { (my  $label = '_anon_' . MiniPerl6::Python::LexicalBlock::get_ident_python());MiniPerl6::Python::LexicalBlock::push_stmt_python(Sub->new( 'name' => $label,'block' => $self->{block},'sig' => $self->{sig}, ));return(Python::tab($level) . $label) } else {  }; (my  $sig = $self->{sig}); (my  $pos = $sig->positional()); my  $List_args; for my $field ( @{$pos} ) { push( @{$List_args}, $field->emit_python() ) }; (my  $block = MiniPerl6::Python::LexicalBlock->new( 'block' => $self->{block},'needs_return' => 1, )); Python::tab($level) . 'def ' . $self->{name} . '(' . Main::join($List_args, ', ') . '):
' . $block->emit_python_indented(($level + 1)) }
}

{
package Do;
sub new { shift; bless { @_ }, "Do" }
sub block { $_[0]->{block} };
sub emit_python { my $self = $_[0]; $self->emit_python_indented(0) };
sub emit_python_indented { my $self = $_[0]; my $level = $_[1]; (my  $label = '_anon_' . MiniPerl6::Python::LexicalBlock::get_ident_python()); MiniPerl6::Python::LexicalBlock::push_stmt_python(Sub->new( 'name' => $label,'block' => $self->{block},'sig' => Sig->new( 'invocant' => (undef),'positional' => [],'named' => {  }, ), )); return(Python::tab($level) . $label . '()') }
}

{
package Use;
sub new { shift; bless { @_ }, "Use" }
sub mod { $_[0]->{mod} };
sub emit_python { my $self = $_[0]; $self->emit_python_indented(0) };
sub emit_python_indented { my $self = $_[0]; my $level = $_[1]; Python::tab($level) . 'from ' . $self->{mod} . 'import *' }
}

1;
