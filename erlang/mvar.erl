-module(mvar).
-export([mvar/0, mvar/1]).

mvar() ->
	receive
		{put, Value, Process} ->  Process ! ok, mvar(Value);
		{tryPut, Value, Process} -> Process ! ok, mvar(Value);
		{isEmpty, Process} -> Process ! true, mvar()
	end.
	
mvar(Value) ->
	receive
		{take, Process}, Process ! Value, mvar();
		{tryTake, Process}, Process ! Value, mvar();
		{read, Process}, Process ! Value, mvar(Value);
		{isEmpty, Process}, Process ! false, mvar(Value);
		{swap, newValue}, Process ! Value, mvar(newValue)
	end.
