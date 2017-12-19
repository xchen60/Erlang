-module(makeup).
-compile(export_all).

start() ->
    Lines = readlines("star.txt"),
    generateSensor(Lines),
    spawn(?MODULE, timer, [Lines, 1500]).

%generate all sensor processes and register them
generateSensor(Lines) ->
    [H|T] = Lines,
    if 
        T /= [] ->
            Node = element(1, H),
            Name = list_to_atom(Node),
            Neighbors = element(2, H),
            InitValue = rand:uniform(200),
            NID = spawn(?MODULE, sensor, [InitValue,Name,Neighbors,0,0]),
            register(Name, NID),
            generateSensor(T);
        T == [] ->
            Node = element(1, H),
            Name = list_to_atom(Node),
            Neighbors = element(2, H),
            InitValue = rand:uniform(200),
            NID = spawn(?MODULE, sensor, [InitValue,Name,Neighbors,0,0]),
            register(Name, NID)
    end.

%sensor server can receive 3 kinds of Msg
sensor(Value, Name, Neighbors, Sum, Count) ->
    receive 
        {directReading, NewValue} ->
            sensor(NewValue, Name, Neighbors, Sum, Count);
        {tick} ->
            io:format("~p temperature is ~w Fahrenheit~n", [Name, Value]),
            sendToNeighbor(Value, Neighbors),
            sensor(Value, Name, Neighbors, 0, 0);
        {fromNei, NeiValue} ->
            if 
                Count < (length(Neighbors) - 1) ->
                    sensor(Value,Name, Neighbors, Sum + NeiValue, Count + 1);
                Count == (length(Neighbors) - 1) ->
                    Avg = (Sum + NeiValue) div (Count + 1),
                    sensor(Avg, Name, Neighbors, 0, 0)
            end
    end.

%send node's value to all neighbors
sendToNeighbor(Value, Neighbors) ->
    [H|T] = Neighbors,
    Name = list_to_atom(H),
    NID = whereis(Name),
    if
        T /= [] ->
            NID ! {fromNei, Value},
            sendToNeighbor(Value, T);
        T == [] ->
            NID ! {fromNei, Value}
    end.

%timer server
timer(Lines, Sleep_time) ->
    timer:sleep(Sleep_time),
    io:format("================New Round================~n"),
    sendTick(Lines),
    timer(Lines, Sleep_time).

%send tick to each Node
sendTick(Lines) ->
    [H|T] = Lines,
    if
        T /= [] ->
            Node = element(1, H),
            Name = list_to_atom(Node),
            NID = whereis(Name),
            NID ! {tick},
            sendTick(T);
        T == [] ->
            Node = element(1, H),
            Name = list_to_atom(Node),
            NID = whereis(Name),
            NID ! {tick}
    end.

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
