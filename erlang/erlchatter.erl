-module(erlchatter).
-export([erlchatter/1]).
-import(lists).


erlchatter(Clients) ->
	receive
		% new Chatter
		{register, Erlchatter} -> 
			lists:map(fun(C) -> C ! {newling, Erlchatter} end, Clients),
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
		{newling,Chatter} -> 
			erlchatter(Clients++[Chatter]);
		{printClients} -> io:format("The clients ~w~n",[Clients]),
			erlchatter(Clients)
	end.