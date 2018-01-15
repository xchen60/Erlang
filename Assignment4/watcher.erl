-module(watcher).
-compile(export_all).
-author("Xiaotong Chen").

start() ->
    {ok, [N]} = io:fread("enter number of sensors> ", "~d"),
    if N =< 1 ->
          io:fwrite("setup: range must be at least 2~n", []);
       true -> 
         Num_watchers = 1 + (N div 10),
         setup_loop(0, N - 1, Num_watchers) 
    end. 

%%Allocate the sensor list to each watcher
setup_loop(Start, End, Num_watchers) ->
    if (Start + 9 =< End) ->
            spawn(watcher, generateWatcher, [Start, Start + 9, Start div 10]),
            setup_loop(Start + 10, End, Num_watchers);
        true ->
            spawn(watcher, generateWatcher, [Start, End, Start div 10])
    end.

%%Generate all watchers
generateWatcher(SensorStart, SensorEnd, WatcherId) ->
    SensorList = generateSensor(SensorStart, SensorEnd, []),
    io:fwrite("The Watcher ~w watches the sensor list ~w~n ", 
              [WatcherId, SensorList]),
    watcherEvent(SensorList, WatcherId).

%%Generate all sensors
generateSensor(Start, End, SensorList) ->
    if (Start =< End) ->
            {Pid, _} = spawn_monitor(sensor, sensorController, [self(), Start]),
            generateSensor(Start + 1, End, SensorList ++ [{Start, Pid}]);
        true -> SensorList
    end.

%%Monitor all received message from sensors for each watcher
watcherEvent(SensorList, WatcherId) ->
    receive 
        %%If the Measurement is 11, then delete the dead sensor and add a new one
        {Sid, crash} ->
            io:fwrite("Sensor ~w is died, the reason is anomalous_reading ~n",[Sid]),
            {Pid, _} = spawn_monitor(sensor, sensorController, [self(), Sid]),
            DeadSensor = findDeadSensor(Sid, SensorList),
            Temp_SensorList = lists:delete(DeadSensor, SensorList),
            New_SensorList = Temp_SensorList ++ [{Sid, Pid}],
            io:fwrite("The Watcher ~w watches NEW sensor list ~w~n ",
                      [WatcherId, New_SensorList]);
        %%If the Measurement isn't 11, the print the Measurement of the sensor.
        {Sid, Msg} ->
            io:fwrite("Watcher ~w receives Sensor ~w Measurement ~w~n ",
                       [WatcherId, Sid, Msg]),
            New_SensorList = SensorList
    end,
    watcherEvent(New_SensorList, WatcherId).

%%Find the dead sensor in orginal SensorList
findDeadSensor(Sid, [Head|Tail]) ->
    if Sid /= element(1, Head) ->
            findDeadSensor(Sid, Tail);
        true ->
            Head
    end.


