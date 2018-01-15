-module(interp).
%% -compile(export_all).
-export([scanAndParse/1,runFile/1,runStr/1]).
-include("types.hrl").

loop(InFile,Acc) ->
    case io:request(InFile,{get_until,prompt,lexer,token,[1]}) of
        {ok,Token,_EndLine} ->
            loop(InFile,Acc ++ [Token]);
        {error,token} ->
            exit(scanning_error);
        {eof,_} ->
            Acc
    end.

scanAndParse(FileName) ->
    {ok, InFile} = file:open(FileName, [read]),
    Acc = loop(InFile,[]),
    file:close(InFile),
    {Result, AST} = parser:parse(Acc),
    case Result of 
	ok -> AST;
	_ -> io:format("Parse error~n")
    end.


-spec runFile(string()) -> valType().
runFile(FileName) ->
    valueOf(scanAndParse(FileName),env:new()).

scanAndParseString(String) ->
    {_ResultL, TKs, _L} = lexer:string(String),
    parser:parse(TKs).

-spec runStr(string()) -> valType().
runStr(String) ->
    {Result, AST} = scanAndParseString(String),
    case Result  of 
    	ok -> valueOf(AST,env:new());
    	_ -> io:format("Parse error~n")
    end.


-spec numVal2Num(numValType()) -> integer().
numVal2Num({num, N}) ->
    N;
numVal2Num({num,_,N}) ->
	N.

-spec boolVal2Bool(boolValType()) -> boolean().
boolVal2Bool({bool, B}) ->
    B.

-spec valueOf(expType(),envType()) -> valType().
valueOf(Exp,Env) ->
	case Exp of 	
		{numExp,N} -> N;
		{idExp,Id} -> env:lookup(Env,Id);
		{diffExp,E1,E2} -> 
			{num,numVal2Num(valueOf(E1,Env)) - numVal2Num(valueOf(E2,Env))};
		{plusExp,E1,E2} -> 
			{num,numVal2Num(valueOf(E1,Env)) + numVal2Num(valueOf(E2,Env))};
		{isZeroExp,Z} -> 
			{bool,numVal2Num(valueOf(Z,Env)) == 0};
		{ifThenElseExp,E1,E2,E3} -> 
			case E1 of
				true -> valueOf(E2,Env);
				_ -> valueOf(E3,Env)
			end;
		{letExp,Id,E1,E2} -> 
			valueOf(E2,env:add(Env,Id,valueOf(E1,Env)));
		{procExp,Id,E} -> 
			{id,1,X} = Id,
			{proc,X,E,Env};
		{appExp,F,E} ->	
			{proc,A,E2,D} = valueOf(F,Env),
			valueOf(E2,env:add(D,A,valueOf(E,Env)))
	end.









