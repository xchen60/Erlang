-module(test).
-compile(export_all).
-author("Xiaotong Chen").

readlines(FileName) ->
    {ok, Device} = file:open(FileName, [read]),
    try get_all_lines(Device)
    after file:close(Device)
    end.

get_all_lines(Device) ->
    case io:get_line(Device, "") of
        eof -> [];
        Line -> Ss = string:tokens(Line, ",\n"),
        [{hd(Ss), tl(Ss)}] ++ get_all_lines(Device)
    end. 

start() ->
    Lines = readlines("star.txt"),
    io:format("~p", [Lines]).
    
hello() ->
    io:format("Hello").    