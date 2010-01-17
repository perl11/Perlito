use v6;

class CompUnit {
    has $.name;
    has %.attributes;
    has %.methods;
    has @.body;
    method emit_parrot {
        my $a := @.body;
        my $item;
        
        # --- SETUP NAMESPACE
        
        my $s :=   
            '.namespace [ ' ~ '"' ~ $.name ~ '"' ~ ' ] ' ~ "\n" ~
            #'.sub "__onload" :load' ~ "\n" ~
            #'.end'                ~ "\n" ~ "\n" ~
            '.sub _ :main :anon'   ~ "\n" ~
            '.end'                 ~ "\n" ~ "\n" ~

        # --- SETUP CLASS VARIABLES

            '.sub ' ~ '"' ~ '_class_vars_' ~ '"' ~ ' :anon' ~ "\n";
        for @$a -> $item {
            if    ( $item.isa( 'Decl' ) )
               && ( $item.decl ne 'has' ) 
            {
                $s := $s ~ $item.emit_parrot;
            }
        };
        $s := $s ~
            '.end' ~ "\n" ~ "\n";

        # --- SUBROUTINES AND METHODS

        for @$a -> $item {
            if   $item.isa( 'Sub'    ) 
              || $item.isa( 'Method' )
            {
                $s := $s ~ $item.emit_parrot;
            }
        };

        # --- AUTOGENERATED ACCESSORS

        for @$a -> $item {
            if    ( $item.isa( 'Decl' ) )
               && ( $item.decl eq 'has' ) 
            {
                my $name := ($item.var).name;
                $s := $s ~
            '.sub ' ~ '"' ~ $name ~ '"' ~ ' :method'       ~ "\n" ~ 
            '  .param pmc val      :optional'    ~ "\n" ~
            '  .param int has_val  :opt_flag'    ~ "\n" ~
            '  unless has_val goto ifelse'       ~ "\n" ~
            '  setattribute self, ' ~ '"' ~ $name ~ '"' ~ ', val' ~ "\n" ~
            '  goto ifend'        ~ "\n" ~
            'ifelse:'             ~ "\n" ~
            '  val = getattribute self, ' ~ '"' ~ $name ~ '"' ~ "\n" ~
            'ifend:'              ~ "\n" ~
            '  .return(val)'      ~ "\n" ~
            '.end'                ~ "\n" ~ "\n";

            }
        };

        # --- IMMEDIATE STATEMENTS

        $s := $s ~ 
            '.sub _ :anon :load :init :outer(' ~ '"' ~ '_class_vars_' ~ '"' ~ ')' ~ "\n" ~
            '  .local pmc self'   ~ "\n" ~
            '  newclass self, ' ~ '"' ~ $.name ~ '"' ~ "\n";
        for @$a -> $item {
            if    ( $item.isa( 'Decl' ) )
               && ( $item.decl eq 'has' ) 
            {
                $s := $s ~ $item.emit_parrot;
            };
            if   $item.isa( 'Decl'   ) 
              || $item.isa( 'Sub'    ) 
              || $item.isa( 'Method' )
            {
                # already done - ignore
            }
            else {
                $s := $s ~ $item.emit_parrot;
            }
        };
        $s := $s ~ 
            '.end' ~ "\n" ~ "\n";
        return $s;
    }
}

#  .namespace [ 'Main' ]
#  .sub _ :anon :load :init
#    print "hello"
#  .end


class Val::Int {
    has $.int;
    method emit_parrot {
        '  $P0 = new .Integer' ~ "\n" ~
        '  $P0 = ' ~ $.int ~ "\n"
    }
}

class Val::Bit {
    has $.bit;
    method emit_parrot {
        '  $P0 = new "Integer"' ~ "\n" ~
        '  $P0 = ' ~ $.bit ~ "\n"
    }
}

class Val::Num {
    has $.num;
    method emit_parrot {
        '  $P0 = new "Float"' ~ "\n" ~
        '  $P0 = ' ~ $.num ~ "\n"
    }
}

class Val::Buf {
    has $.buf;
    method emit_parrot {
        '  $P0 = new "String"' ~ "\n" ~
        '  $P0 = ' ~ '"' ~ $.buf ~ '"' ~ "\n"
    }
}

class Val::Undef {
    method emit_parrot {
        '  $P0 = new .Undef' ~ "\n"
    }
}

class Val::Object {
    has $.class;
    has %.fields;
    method emit_parrot {
        die 'Val::Object - not used yet';
        # 'bless(' ~ %.fields.perl ~ ', ' ~ $.class.perl ~ ')';
    }
}

class Lit::Seq {
    has @.seq;
    method emit_parrot {
        die 'Lit::Seq - not used yet';
        # '(' ~ (@.seq.>>emit_parrot).join('') ~ ')';
    }
}

class Lit::Array {
    has @.array1;
    method emit_parrot {
        my $a := @.array1;
        my $item;
        my $s := 
            '  save $P1' ~ "\n" ~
            '  $P1 = new .ResizablePMCArray' ~ "\n";
        for @$a -> $item {
            $s := $s ~ $item.emit_parrot;
            $s := $s ~ 
            '  push $P1, $P0' ~ Main.newline;
        };
        my $s := $s ~ 
            '  $P0 = $P1' ~ "\n" ~
            '  restore $P1' ~ "\n";
        return $s;
    }
}

class Lit::Hash {
    has @.hash1;
    method emit_parrot {
        my $a := @.hash1;
        my $item;
        my $s := 
            '  save $P1' ~ "\n" ~
            '  save $P2' ~ "\n" ~
            '  $P1 = new .Hash' ~ "\n";
        for @$a -> $item {
            $s := $s ~ ($item[0]).emit_parrot;
            $s := $s ~ 
            '  $P2 = $P0' ~ Main.newline;
            $s := $s ~ ($item[1]).emit_parrot;
            $s := $s ~ 
            '  set $P1[$P2], $P0' ~ Main.newline;
        };
        my $s := $s ~ 
            '  $P0 = $P1'   ~ "\n" ~
            '  restore $P2' ~ "\n" ~
            '  restore $P1' ~ "\n";
        return $s;
    }
}

class Lit::Code {
    method emit_parrot {
        die 'Lit::Code - not used yet';
    }
}

class Lit::Object {
    has $.class;
    has @.fields;
    method emit_parrot {
        # Type.new( 'value' => 42 )
        my $fields := @.fields;
        my $str := '';        
        $str := 
            '  save $P1' ~ "\n" ~
            '  save $S2' ~ "\n" ~
            '  $P1 = new ' ~ '"' ~ $.class ~ '"' ~ "\n";
        for @$fields -> $field {
            $str := $str ~ 
                ($field[0]).emit_parrot ~ 
                '  $S2 = $P0'    ~ "\n" ~
                ($field[1]).emit_parrot ~ 
                '  setattribute $P1, $S2, $P0' ~ "\n";
        };
        $str := $str ~ 
            '  $P0 = $P1'   ~ "\n" ~
            '  restore $S2' ~ "\n" ~
            '  restore $P1' ~ "\n";
        $str;
    }
}

class Index {
    has $.obj;
    has $.index;
    method emit_parrot {
        my $s := 
            '  save $P1'  ~ "\n";
        $s := $s ~ $.obj.emit_parrot;
        $s := $s ~ 
            '  $P1 = $P0' ~ Main.newline();
        $s := $s ~ $.index.emit_parrot;
        $s := $s ~ 
            '  $P0 = $P1[$P0]' ~ Main.newline();
        my $s := $s ~ 
            '  restore $P1' ~ "\n";
        return $s;
    }
}

class Lookup {
    has $.obj;
    has $.index;
    method emit_parrot {
        my $s := 
            '  save $P1'  ~ "\n";
        $s := $s ~ $.obj.emit_parrot;
        $s := $s ~ 
            '  $P1 = $P0' ~ Main.newline;
        $s := $s ~ $.index.emit_parrot;
        $s := $s ~ 
            '  $P0 = $P1[$P0]' ~ Main.newline;
        my $s := $s ~ 
            '  restore $P1' ~ "\n";
        return $s;
    }
}

# variables can be:
# $.var   - inside a method - parrot 'attribute'
# $.var   - inside a class  - parrot 'global' (does parrot have class attributes?)
# my $var - inside a sub or method   - parrot 'lexical' 
# my $var - inside a class  - parrot 'global'
# parameters - parrot subroutine parameters - fixed by storing into lexicals

class Var {
    has $.sigil;
    has $.twigil;
    has $.name;
    method emit_parrot {
           ( $.twigil eq '.' )
        ?? ( 
             '  $P0 = getattribute self, \'' ~ $.name ~ '\'' ~ "\n" 
           )
        !! (
             '  $P0 = ' ~ self.full_name ~ ' ' ~ "\n" 
             # '  $P0 = find_lex \'' ~ self.full_name ~ '\'' ~ "\n" 
           )
    };
    # method name {
    #    $.name
    # };
    method full_name {
        # Normalize the sigil here into $
        # $x    => $x
        # @x    => $List_x
        # %x    => $Hash_x
        # &x    => $Code_x
        my $table := {
            '$' => 'scalar_',
            '@' => 'list_',
            '%' => 'hash_',
            '&' => 'code_',
        };
           ( $.twigil eq '.' )
        ?? ( 
             $.name 
           )
        !!  (    ( $.name eq '/' )
            ??   ( $table{$.sigil} ~ 'MATCH' )
            !!   ( $table{$.sigil} ~ $.name )
            )
    };
}

class Bind {
    has $.parameters;
    has $.arguments;
    method emit_parrot {
        if $.parameters.isa( 'Lit::Array' ) {

            #  [$a, [$b, $c]] := [1, [2, 3]]

            my $a := $.parameters.array1;
            my $b := $.arguments.array1;
            my $str := '';
            my $i := 0;
            for @$a -> $var {
                my $bind := Bind.new( 'parameters' => $var, 'arguments' => ($b[$i]) );
                $str := $str ~ $bind.emit_parrot;
                $i := $i + 1;
            };
            return $str ~ $.parameters.emit_parrot;
        };
        if $.parameters.isa( 'Lit::Hash' ) {

            #  {:$a, :$b} := { a => 1, b => [2, 3]}

            my $a := $.parameters.hash;
            my $b := $.arguments.hash;
            my $str := '';
            my $i := 0;
            my $arg;
            for @$a -> $var {
                $arg := Val::Undef.new();
                for @$b -> $var2 {
                    if ($var2[0]).buf eq ($var[0]).buf {
                        $arg := $var2[1];
                    }
                };
                my $bind := Bind.new( 'parameters' => $var[1], 'arguments' => $arg );
                $str := $str ~ $bind.emit_parrot;
                $i := $i + 1;
            };
            return $str ~ $.parameters.emit_parrot;
        };
        if $.parameters.isa( 'Lit::Object' ) {

            #  Obj.new(:$a, :$b) := $obj

            my $class := $.parameters.class;
            my $a     := $.parameters.fields;
            my $b     := $.arguments;
            my $str   := '';
            for @$a -> $var {
                my $bind := Bind.new( 
                    'parameters' => $var[1], 
                    'arguments'  => Call.new( 
                        invocant  => $b, 
                        method    => ($var[0]).buf, 
                        arguments => [ ], 
                        hyper     => 0 
                    )
                );
                $str := $str ~ $bind.emit_parrot;
            };
            return $str ~ $.parameters.emit_parrot;
        };
        if $.parameters.isa( 'Var' ) {
            return
                $.arguments.emit_parrot ~
                '  ' ~ $.parameters.full_name ~ ' = $P0' ~ "\n";
                #'  store_lex \'' ~ $.parameters.full_name ~ '\', $P0' ~ "\n";
        };
        if $.parameters.isa( 'Decl' ) {
            return
                $.arguments.emit_parrot ~
                '  .local pmc ' ~ (($.parameters).var).full_name     ~ "\n" ~
                '  ' ~ (($.parameters).var).full_name ~ ' = $P0'     ~ "\n" ~
                '  .lex \'' ~ (($.parameters).var).full_name ~ '\', $P0' ~ "\n";
                #'  store_lex \'' ~ (($.parameters).var).full_name ~ '\', $P0' ~ "\n";
        };
        if $.parameters.isa( 'Lookup' ) {
            my $param := $.parameters;
            my $obj   := $param.obj;
            my $index := $param.index;
            return
                $.arguments.emit_parrot ~
                '  save $P2'  ~ "\n" ~
                '  $P2 = $P0' ~ "\n" ~
                '  save $P1'  ~ "\n" ~
                $obj.emit_parrot     ~
                '  $P1 = $P0' ~ "\n" ~
                $index.emit_parrot   ~
                '  $P1[$P0] = $P2' ~ "\n" ~
                '  restore $P1' ~ "\n" ~
                '  restore $P2' ~ "\n";
        };
        if $.parameters.isa( 'Index' ) {
            my $param := $.parameters;
            my $obj   := $param.obj;
            my $index := $param.index;
            return
                $.arguments.emit_parrot ~
                '  save $P2'  ~ "\n" ~
                '  $P2 = $P0' ~ "\n" ~
                '  save $P1'  ~ "\n" ~
                $obj.emit_parrot     ~
                '  $P1 = $P0' ~ "\n" ~
                $index.emit_parrot   ~
                '  $P1[$P0] = $P2' ~ "\n" ~
                '  restore $P1' ~ "\n" ~
                '  restore $P2' ~ "\n";
        };
        die 'Not implemented binding: ' ~ $.parameters ~ "\n" ~ $.parameters.emit_parrot;
    }
}

class Proto {
    has $.name;
    method emit_parrot {
        '  $P0 = ' ~ $.name ~ "\n"
    }
}

class Call {
    has $.invocant;
    has $.hyper;
    has $.method;
    has @.arguments;
    #has $.hyper;
    method emit_parrot {
        if     ($.method eq 'perl')
            || ($.method eq 'yaml')
            || ($.method eq 'say' )
            || ($.method eq 'join')
            # || ($.method eq 'chars')
            # || ($.method eq 'isa')
        {
            if ($.hyper) {
                return
                    '[ map { Main::' ~ $.method ~ '( $_, ' ~ ', ' ~ (@.arguments.>>emit_parrot).join('') ~ ')' ~ ' } @{ ' ~ $.invocant.emit_parrot ~ ' } ]';
            }
            else {
                return
                    'Main::' ~ $.method ~ '(' ~ $.invocant.emit_parrot ~ ', ' ~ (@.arguments.>>emit_parrot).join('') ~ ')';
            }
        };

        my $meth := $.method;
        if  $meth eq 'postcircumfix:<( )>'  {
             $meth := '';
        };

        my $call := '->' ~ $meth ~ '(' ~ (@.arguments.>>emit_parrot).join('') ~ ')';
        if ($.hyper) {
            return '[ map { $_' ~ $call ~ ' } @{ ' ~ $.invocant.emit_parrot ~ ' } ]';
        };

        # TODO - arguments
        #$.invocant.emit_parrot ~
        #'  $P0.' ~ $meth ~ '()' ~ Main.newline;

        my @args := @.arguments;
        my $str := '';
        my $ii := 10;
        for @args -> $arg {
            $str := $str ~ '  save $P' ~ $ii ~ "\n";
            $ii := $ii + 1;
        };
        my $i := 10;
        for @args -> $arg {
            $str := $str ~ $arg.emit_parrot ~
                '  $P' ~ $i ~ ' = $P0' ~ "\n";
            $i := $i + 1;
        };
        $str := $str ~ $.invocant.emit_parrot ~
            '  $P0 = $P0.' ~ $meth ~ '('; 
        #$str := $str ~ '  ' ~ $.code ~ '(';
        $i := 0;
        my @p;
        for @args -> $arg {
            @p[$i] := '$P' ~ ($i+10);
            $i := $i + 1;
        };
        $str := $str ~ @p.join(', ') ~ ')' ~ "\n";
        for @args -> $arg {
            $ii := $ii - 1;
            $str := $str ~ '  restore $P' ~ $ii ~ "\n";
        };
        return $str;
    }
}

class Apply {
    has $.code;
    has @.arguments;
    my $label := 100;
    method emit_parrot {

        my $code := $.code;

        if $code eq 'die'        {
            return
                '  $P0 = new .Exception' ~ "\n" ~
                '  $P0[' ~ '"' ~ '_message' ~ '"' ~ '] = ' ~ '"' ~ 'something broke' ~ '"' ~ "\n" ~
                '  throw $P0' ~ "\n";
        };

        if $code eq 'say'        {
            return
                (@.arguments.>>emit_parrot).join( '  print $P0' ~ "\n" ) ~
                '  print $P0' ~ "\n" ~
                '  print ' ~ '"' ~ '\\' ~ 'n' ~ '"' ~ "\n"
        };
        if $code eq 'print'      {
            return
                (@.arguments.>>emit_parrot).join( '  print $P0' ~ "\n" ) ~
                '  print $P0' ~ "\n" 
        };
        if $code eq 'array'      { 
            return '  # TODO - array() is no-op' ~ "\n";
        };

        if $code eq 'prefix:<~>' { 
            return 
                (@.arguments[0]).emit_parrot ~
                '  $S0 = $P0'    ~ "\n" ~
                '  $P0 = $S0'    ~ "\n";
        };
        if $code eq 'prefix:<!>' {  
            return 
                ( If.new( cond      => @.arguments[0],
                        body      => [ Val::Bit.new( bit => 0 ) ],
                        otherwise => [ Val::Bit.new( bit => 1 ) ] 
                ) ).emit_parrot;
        };
        if $code eq 'prefix:<?>' {  
            return 
                ( If.new( cond      => @.arguments[0],
                        body      => [ Val::Bit.new( bit => 1 ) ],
                        otherwise => [ Val::Bit.new( bit => 0 ) ] 
                ) ).emit_parrot;
        };

        if $code eq 'prefix:<$>' { 
            return '  # TODO - prefix:<$> is no-op' ~ "\n";
        };
        if $code eq 'prefix:<@>' { 
            return '  # TODO - prefix:<@> is no-op' ~ "\n";
        };
        if $code eq 'prefix:<%>' { 
            return '  # TODO - prefix:<%> is no-op' ~ "\n";
        };
        
        if $code eq 'infix:<~>'  { 
            return 
                (@.arguments[0]).emit_parrot ~
                '  $S0 = $P0'    ~ "\n" ~
                '  save $S0'     ~ "\n" ~
                (@.arguments[1]).emit_parrot ~
                '  $S1 = $P0'    ~ "\n" ~
                '  restore $S0'  ~ "\n" ~
                '  $S0 = concat $S0, $S1' ~ "\n" ~
                '  $P0 = $S0'    ~ "\n";
        };
        if $code eq 'infix:<+>'  { 
            return 
                '  save $P1'        ~ "\n" ~
                (@.arguments[0]).emit_parrot ~
                '  $P1 = $P0'       ~ "\n" ~
                (@.arguments[1]).emit_parrot ~
                '  $P0 = $P1 + $P0' ~ "\n" ~
                '  restore $P1'     ~ "\n"
        };
        if $code eq 'infix:<->'  { 
            return 
                '  save $P1'        ~ "\n" ~
                (@.arguments[0]).emit_parrot ~
                '  $P1 = $P0'       ~ "\n" ~
                (@.arguments[1]).emit_parrot ~
                '  $P0 = $P1 - $P0' ~ "\n" ~
                '  restore $P1'     ~ "\n"
        };

        if $code eq 'infix:<&&>' {  
            return 
                ( If.new( cond => @.arguments[0],
                        body => [@.arguments[1]],
                        otherwise => [ ]
                ) ).emit_parrot;
        };

        if $code eq 'infix:<||>' {  
            return 
                ( If.new( cond => @.arguments[0],
                        body => [ ],
                        otherwise => [@.arguments[1]] 
                ) ).emit_parrot;
        };

        if $code eq 'infix:<eq>' { 
            $label := $label + 1;
            my $id := $label;
            return
                (@.arguments[0]).emit_parrot ~
                '  $S0 = $P0'    ~ "\n" ~
                '  save $S0'     ~ "\n" ~
                (@.arguments[1]).emit_parrot ~
                '  $S1 = $P0'    ~ "\n" ~
                '  restore $S0'  ~ "\n" ~
                '  if $S0 == $S1 goto eq' ~ $id ~ "\n" ~
                '  $P0 = 0'      ~ "\n" ~
                '  goto eq_end' ~ $id ~ "\n" ~
                'eq' ~ $id ~ ':' ~ "\n" ~
                '  $P0 = 1'      ~ "\n" ~
                'eq_end'  ~ $id ~ ':'  ~ "\n";
        };
        if $code eq 'infix:<ne>' { 
            $label := $label + 1;
            my $id := $label;
            return
                (@.arguments[0]).emit_parrot ~
                '  $S0 = $P0'    ~ "\n" ~
                '  save $S0'     ~ "\n" ~
                (@.arguments[1]).emit_parrot ~
                '  $S1 = $P0'    ~ "\n" ~
                '  restore $S0'  ~ "\n" ~
                '  if $S0 == $S1 goto eq' ~ $id ~ "\n" ~
                '  $P0 = 1'      ~ "\n" ~
                '  goto eq_end' ~ $id ~ "\n" ~
                'eq' ~ $id ~ ':' ~ "\n" ~
                '  $P0 = 0'      ~ "\n" ~
                'eq_end'  ~ $id ~ ':'  ~ "\n";
        };
        if $code eq 'infix:<==>' { 
            $label := $label + 1;
            my $id := $label;
            return
                '  save $P1'     ~ "\n" ~
                (@.arguments[0]).emit_parrot ~
                '  $P1 = $P0'    ~ "\n" ~
                (@.arguments[1]).emit_parrot ~
                '  if $P0 == $P1 goto eq' ~ $id ~ "\n" ~
                '  $P0 = 0'      ~ "\n" ~
                '  goto eq_end' ~ $id ~ "\n" ~
                'eq' ~ $id ~ ':' ~ "\n" ~
                '  $P0 = 1'      ~ "\n" ~
                'eq_end'  ~ $id ~ ':'  ~ "\n" ~
                '  restore $P1'  ~ "\n";
        };
        if $code eq 'infix:<!=>' { 
            $label := $label + 1;
            my $id := $label;
            return
                '  save $P1'     ~ "\n" ~
                (@.arguments[0]).emit_parrot ~
                '  $P1 = $P0'    ~ "\n" ~
                (@.arguments[1]).emit_parrot ~
                '  if $P0 == $P1 goto eq' ~ $id ~ "\n" ~
                '  $P0 = 1'      ~ "\n" ~
                '  goto eq_end' ~ $id ~ "\n" ~
                'eq' ~ $id ~ ':' ~ "\n" ~
                '  $P0 = 0'      ~ "\n" ~
                'eq_end'  ~ $id ~ ':'  ~ "\n" ~
                '  restore $P1'  ~ "\n";
        };

        if $code eq 'ternary:<?? !!>' { 
            return 
                ( If.new( cond => @.arguments[0],
                        body => [@.arguments[1]],
                        otherwise => [@.arguments[2]] 
                ) ).emit_parrot;
        };

        if $code eq 'defined'  { 
            return 
                (@.arguments[0]).emit_parrot ~
                '  $I0 = defined $P0' ~ "\n" ~
                '  $P0 = $I0' ~ "\n";
        };

        if $code eq 'substr'  { 
            return 
                (@.arguments[0]).emit_parrot ~
                '  $S0 = $P0'    ~ "\n" ~
                '  save $S0'     ~ "\n" ~
                (@.arguments[1]).emit_parrot ~
                '  $I0 = $P0'    ~ "\n" ~
                '  save $I0'     ~ "\n" ~
                (@.arguments[2]).emit_parrot ~
                '  $I1 = $P0'    ~ "\n" ~
                '  restore $I0'  ~ "\n" ~
                '  restore $S0'  ~ "\n" ~
                '  $S0 = substr $S0, $I0, $I1' ~ "\n" ~
                '  $P0 = $S0'    ~ "\n";
        };

        #(@.arguments.>>emit_parrot).join('') ~
        #'  ' ~ $.code ~ '( $P0 )' ~ "\n";
        
        my @args := @.arguments;
        my $str := '';
        my $ii := 10;
        my $arg;
        for @args -> $arg {
            $str := $str ~ '  save $P' ~ $ii ~ "\n";
            $ii := $ii + 1;
        };
        my $i := 10;
        for @args -> $arg {
            $str := $str ~ $arg.emit_parrot ~
                '  $P' ~ $i ~ ' = $P0' ~ "\n";
            $i := $i + 1;
        };
        $str := $str ~ '  $P0 = ' ~ $.code ~ '(';
        $i := 0;
        my @p;
        for @args -> $arg {
            @p[$i] := '$P' ~ ($i+10);
            $i := $i + 1;
        };
        $str := $str ~ @p.join(', ') ~ ')' ~ "\n";
        for @args -> $arg {
            $ii := $ii - 1;
            $str := $str ~ '  restore $P' ~ $ii ~ "\n";
        };
        return $str;
    }
}

class Return {
    has $.result;
    method emit_parrot {
        $.result.emit_parrot ~ 
        '  .return( $P0 )' ~ "\n";
    }
}

class If {
    has $.cond;
    has @.body;
    has @.otherwise;
    my $label := 100;
    method emit_parrot {
        $label := $label + 1;
        my $id := $label;
        return
            $.cond.emit_parrot ~ 
            '  unless $P0 goto ifelse' ~ $id ~ "\n" ~
                (@.body.>>emit_parrot).join('') ~ 
            '  goto ifend' ~ $id ~ "\n" ~
            'ifelse' ~ $id ~ ':' ~ "\n" ~
                (@.otherwise.>>emit_parrot).join('') ~ 
            'ifend'  ~ $id ~ ':'  ~ "\n";
    }
}

class For {
    has $.cond;
    has @.body;
    has @.topic;
    my $label := 100;
    method emit_parrot {
        my $cond := $.cond;
        $label := $label + 1;
        my $id := $label;
        if   $cond.isa( 'Var' )
          && $cond.sigil ne '@'
        {
            $cond := Lit::Array.new( array1 => [ $cond ] );
        };
        return
            '' ~ 
            $cond.emit_parrot ~
            '  save $P1' ~ "\n" ~
            '  save $P2' ~ "\n" ~
            '  $P1 = new .Iterator, $P0' ~ "\n" ~
            ' test_iter'  ~ $id ~ ':' ~ "\n" ~
            '  unless $P1 goto iter_done'  ~ $id ~ "\n" ~
            '  $P2 = shift $P1' ~ "\n" ~
            '  store_lex \'' ~ $.topic.full_name ~ '\', $P2' ~ "\n" ~
            (@.body.>>emit_parrot).join('') ~
            '  goto test_iter'  ~ $id ~ "\n" ~
            ' iter_done'  ~ $id ~ ':' ~ "\n" ~
            '  restore $P2' ~ "\n" ~
            '  restore $P1' ~ "\n" ~
            ''; 
    }
}

class Decl {
    has $.decl;
    has $.type;
    has $.var;
    method emit_parrot {
        my $decl := $.decl;
        my $name := $.var.name;
           ( $decl eq 'has' )
        ?? ( '  addattribute self, ' ~ '"' ~ $name ~ '"' ~ "\n" )
        !! #$.decl ~ ' ' ~ $.type ~ ' ' ~ $.var.emit_parrot;
           ( '  .local pmc ' ~ ($.var).full_name ~ ' ' ~ "\n" ~
             '  .lex \'' ~ ($.var).full_name ~ '\', ' ~ ($.var).full_name ~ ' ' ~ "\n" 
           );
    }
}

class Sig {
    has $.invocant;
    has $.positional;
    has $.named;
    method emit_parrot {
        ' print \'Signature - TODO\'; die \'Signature - TODO\'; '
    };
    #method invocant {
    #    $.invocant
    #};
    #method positional {
    #    $.positional
    #}
}

class Method {
    has $.name;
    has $.sig;
    has @.block;
    method emit_parrot {
        my $sig := $.sig;
        my $invocant := $sig.invocant;
        my $pos := $sig.positional;
        my $str := '';
        my $i := 0;
        my $field;
        for @$pos -> $field {
            $str := $str ~ 
                '  $P0 = params[' ~ $i ~ ']' ~ "\n" ~
                '  .lex \'' ~ $field.full_name ~ '\', $P0' ~ "\n";
            $i := $i + 1;
        };
        return          
            '.sub ' ~ '"' ~ $.name ~ '"' ~ 
                ' :method :outer(' ~ '"' ~ '_class_vars_' ~ '"' ~ ')' ~ "\n" ~
            '  .param pmc params  :slurpy'  ~ "\n" ~
            '  .lex \'' ~ $invocant.full_name ~ '\', self' ~ "\n" ~
            $str ~
            (@.block.>>emit_parrot).join('') ~ 
            '.end' ~ "\n" ~ "\n";
    }
}

class Sub {
    has $.name;
    has $.sig;
    has @.block;
    method emit_parrot {
        my $sig := $.sig;
        my $invocant := $sig.invocant;
        my $pos := $sig.positional;
        my $str := '';
        my $i := 0;
        my $field;
        for @$pos -> $field {
            $str := $str ~ 
                '  $P0 = params[' ~ $i ~ ']' ~ "\n" ~
                '  .lex \'' ~ $field.full_name ~ '\', $P0' ~ "\n";
            $i := $i + 1;
        };
        return          
            '.sub ' ~ '"' ~ $.name ~ '"' ~ 
                ' :outer(' ~ '"' ~ '_class_vars_' ~ '"' ~ ')' ~ "\n" ~
            '  .param pmc params  :slurpy'  ~ "\n" ~
            $str ~
            (@.block.>>emit_parrot).join('') ~ 
            '.end' ~ "\n" ~ "\n";
    }
}

class Do {
    has @.block;
    method emit_parrot {
        # TODO - create a new lexical pad
        (@.block.>>emit_parrot).join('') 
    }
}

class Use {
    has $.mod;
    method emit_parrot {
        '  .include ' ~ '"' ~ $.mod ~ '"' ~ "\n"
    }
}

=begin

=head1 NAME

MiniPerl6::Parrot::Emit - Code generator for MiniPerl6-in-Parrot

=head1 SYNOPSIS

    $program.emit_parrot  # generated Parrot code

=head1 DESCRIPTION

This module generates Parrot code for the MiniPerl6 compiler.

=head1 AUTHORS

The Pugs Team E<lt>perl6-compiler@perl.orgE<gt>.

=head1 SEE ALSO

The Perl 6 homepage at L<http://dev.perl.org/perl6>.

The Pugs homepage at L<http://pugscode.org/>.

=head1 COPYRIGHT

Copyright 2006 by Flavio Soibelmann Glock, Audrey Tang and others.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=end
