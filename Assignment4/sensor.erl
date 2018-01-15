-module(sensor).
-compile(export_all).
-author("Xiaotong Chen").

sensorController(Wid, Sid) ->
    %%Generate a random measurement and sleeping time
    Measurement = rand:uniform(11),
    Sleep_time = rand:uniform(10000),
    %%Sleep for a moment
    timer:sleep(Sleep_time),
    %%Controller logic
    if 
        Measurement == 11 -> 
            Wid ! {Sid, crash},
            exit(anomalous_reading);
        true -> Wid ! {Sid, Measurement}
    end,
    sensorController(Wid, Sid).