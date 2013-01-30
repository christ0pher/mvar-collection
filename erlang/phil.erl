-module(phil).
-export([start/0, fork/0, taken/0, phil/3]).

start() ->
	Fork1 = spawn(phil, fork, []),
	Fork2 = spawn(phil, fork, []),
	Fork3 = spawn(phil, fork, []),
	Fork4 = spawn(phil, fork, []),
	Fork5 = spawn(phil, fork, []),
	spawn(phil, phil, ["Gerd", Fork1, Fork2]),
	spawn(phil, phil, ["Anna", Fork2, Fork3]),
	spawn(phil, phil, ["Ulli", Fork3, Fork4]),
	spawn(phil, phil, ["Sara", Fork4, Fork5]),
	spawn(phil, phil, ["Rudi", Fork5, Fork1]).
	

phil(Name, ForkLeft, ForkRight) ->
	% take left fork
	ForkLeft ! {take, self()},
	receive
		ok -> ok;
		busy -> base:putStrLn(Name ++ " left fork in use, retrying"),
				phil(Name, ForkLeft, ForkRight)
	end,
	
	% take right fork
	ForkRight ! {take, self()},
	receive
		ok -> ok;
		busy -> ForkLeft ! {release, self()},
				base:putStrLn(Name ++ " right fork in use, retrying"),
				phil(Name, ForkLeft, ForkRight)
	end,
	
	% got both forks -> eat
	base:putStrLn(Name ++ " eating"),

	% puts forks back
	ForkLeft ! {release, self()},
	ForkRight ! {release, self()},

	% think
	base:putStrLn(Name ++ " thinking"),
	timer:sleep(500),
	phil(Name, ForkLeft, ForkRight).
	



fork() ->
	receive
		{take, Phil} -> Phil ! ok,
						taken()
	end.

taken() ->
	receive	
		{take, Phil} -> Phil ! busy,
						taken();
		{release, _} -> fork()
	end.