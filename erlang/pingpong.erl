-module(pingpong).
-export([pingTest/0,ping/0]).

pingTest() -> spawn(pingpong, ping, []).

ping() ->
	receive
		{ping, Pids} -> Pids ! pong, 
						io:format("got ping",[]),
						ping();
		_ -> io:format("Ping finished~n", [])
	end.
	