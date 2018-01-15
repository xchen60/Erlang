Nonterminals
expression.

Terminals 
num id 'proc' 'isZero' 'if' 'then' 'else' 'let'  'in' minus plus oParen cParen equals comma.

Rootsymbol expression.

expression -> num : {numExp, '$1'}.
expression -> id : {idExp, '$1'}.
expression -> minus oParen expression comma expression cParen : {diffExp, '$3', '$5'}.
expression -> plus oParen expression comma expression cParen : {plusExp, '$3', '$5'}.
expression -> 'isZero' oParen expression cParen  : {isZeroExp, '$3'}.

expression -> 'if' expression 'then' expression 'else' expression  : 
              {ifThenElseExp, '$2', '$4', '$6'}.

expression -> 'let' id equals expression 'in' expression  : 
              {letExp, '$2', '$4', '$6'}.
expression -> 'proc' oParen id cParen expression : 
            {procExp, '$3', '$5'}.

expression -> expression oParen expression cParen : 
            {appExp, '$1', '$3'}.

expression -> oParen expression cParen : '$2'.
      
%% list -> '(' ')' : nil.
%% list -> '(' elements ')' : {list,'$2'}.

%% elements -> element : ['$1'].
%% elements -> element ',' elements : ['$1'] ++ '$3'.
%% element -> atom : '$1'.
%% element -> var : unwrap('$1').
%% element -> integer : unwrap('$1').
%% element -> string : unwrap('$1').

Erlang code.

%unwrap({_,_,V}) -> V.



  % (define the-grammar
  %   '((program (expression) a-program)
      
  %     (expression (number) const-exp)
  %     (expression
  %      ("-" "(" expression "," expression ")")
  %      diff-exp)
      
  %     (expression
  %      ("*" "(" expression "," expression ")")
  %      prod-exp)
      
  %     (expression
  %      ("zero?" "(" expression ")")
  %      zero?-exp)
      
  %     (expression
  %      ("if" expression "then" expression "else" expression)
  %      if-exp)
      
  %     (expression (identifier) var-exp)
      
  %     (expression
  %      ("let" identifier "=" expression "in" expression)
  %      let-exp)   
      
  %     (expression
  %      ("proc" "(" identifier ")" expression)
  %      proc-exp)
      
  %     (expression
  %      ("(" expression expression ")")
  %      call-exp)
      
  %     ))
