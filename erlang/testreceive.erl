-module(testreceive).
-export([loop/0]).

loop() ->
	receive
		{A, B, C} ->
			io:format("a + b * c is ~p~n", [A + (B * C)]),
			loop();
		{A, B} ->
			io:format("a * b is ~p~n", [A * B]),
			loop();
		{A} ->
			io:format("a ^ 2 is ~p~n", [A * A]),
			loop()
	end.