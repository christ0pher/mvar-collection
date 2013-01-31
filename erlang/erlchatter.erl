-module(erlchatter).
-export([erlchatter/1]).
-import(lists).


erlchatter(Clients) ->
	receive
		% new Chatter
		{register, Erlchatter} -> 
			lists:map(fun(C) -> C ! {newling, Clients++[Erlchatter]++[self()]} end, Clients),
			Erlchatter ! {otherClients, Clients++[self()]},
			erlchatter(Clients++[Erlchatter]);
		% send a message
		{receives, Message} -> 
			io:format("Received the ChatMessage: ~s~n",[Message]),
			erlchatter(Clients);
		{sent, Message} -> 
			lists:map(fun(C) -> C ! {receives, Message} end, Clients),
			erlchatter(Clients);
		% 
		{otherClients, Clientlist} -> 
			erlchatter(Clients++Clientlist);
		{newling,Chatters} -> 
			All = Clients++[self()]
		    NewClients = Clients++lists:filter(fun(X) -> not lists:member(X, All) end, Chatters)
			erlchatter(NewClients);
		{printClients} -> io:format("The clients ~w~n",[Clients]),
			erlchatter(Clients)
	end.