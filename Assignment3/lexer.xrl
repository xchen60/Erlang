Definitions.

Id = [a-z][0-9a-zA-Z_]*

Num = [0-9][0-9]*

NNum = -[0-9][0-9]*

WhiteSpace  = [\s\t\n\r]+

Proc    = proc

IsZero  = zero\?

If    = if

Then    = then

Else = else

In = in

Let = let

Rules.


{Proc} :
  {token,{'proc',TokenLine,TokenChars}}.

{IsZero} :
  {token,{'isZero',TokenLine,TokenChars}}.

{If} :
  {token,{'if',TokenLine,TokenChars}}.

{Then} :
  {token,{'then',TokenLine,TokenChars}}.

{Else} :
  {token,{'else',TokenLine,TokenChars}}.

{Let} :
  {token,{'let',TokenLine,TokenChars}}.

{In} :
  {token,{'in',TokenLine,TokenChars}}.

{Num} :
  {token,{num,TokenLine,list_to_integer(TokenChars)}}.

{NNum} :
  {token,{num,TokenLine,list_to_integer(TokenChars)}}.

{WhiteSpace} : skip_token.

{Id} :
  {token,{id,TokenLine,list_to_atom(TokenChars)}}.

\- :
  {token, {minus, TokenLine, TokenChars}}.

\+ :
  {token, {plus, TokenLine, TokenChars}}.

\( :
  {token, {oParen, TokenLine, TokenChars}}.

\) :
  {token, {cParen, TokenLine, TokenChars}}.

\= :
  {token, {equals, TokenLine, TokenChars}}.

\, :
  {token, {comma, TokenLine, TokenChars}}.



Erlang code.

% Definitions.


% L   = [A-Za-z]
% WS  = ([\000-\s]|%.*)
% C   = (<|<=|=|=>|>)

% Rules.

% in     : {token,{set,TokenLine,list_to_atom(TokenChars)}}.
% or     : {token,{union,TokenLine,list_to_atom(TokenChars)}}.
% and    : {token,{intersection,TokenLine,list_to_atom(TokenChars)}}.
% {C}    : {token,{comparator,TokenLine,list_to_atom(TokenChars)}}.
% '{L}+' : S = strip(TokenChars,TokenLen),
%          {token,{string,TokenLine,S}}.
% {L}+   : {token,{var,TokenLine,list_to_atom(TokenChars)}}.
% {D}+   : {token,{integer,TokenLine,list_to_integer(TokenChars)}}.
% [(),]  : {token,{list_to_atom(TokenChars),TokenLine}}.
% {WS}+  : skip_token.

% Erlang code.

% atom(TokenChars) -> list_to_atom(TokenChars)

% strip(TokenChars,TokenLen) ->
%     lists:sublist(TokenChars, 2, TokenLen - 2).
