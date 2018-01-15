-module(env).
-compile(export_all).
-include("types.hrl").


-spec new()-> envType().
new() ->
    % complete
	dict:new().

-spec add(envType(),atom(),valType())-> envType().
add(Env,Key,Value) ->
    % complete
	dict:store(Key, Value, Env).

-spec lookup(envType(),atom())-> valType().
lookup(Env,Key) -> 
	% complete
	dict:fetch(Key, Env).

