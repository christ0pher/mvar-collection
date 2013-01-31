-module(sieve).
-export([start/0,checkSieve/2,allNumbers/1,sieve/2, collect/1, revealUntil/2]).

start() ->
	AllNum = spawn(sieve, allNumbers, [2]),
	HeadSieve = spawn(sieve,sieve,[2, AllNum]),
	spawn(sieve, collect, [HeadSieve]).

collect(HeadSieve) ->
	receive 
		{reveal, From} ->
			HeadSieve ! {getPrime, self()},
			receive
				{prime, Prime, NewHeadSieve} ->
					io:format("The new Prime revealed: ~p~n",[Prime]),
					From ! {currentPrime, Prime},
					collect(NewHeadSieve)
			end
	end.

revealUntil (Prime, Collect) ->
	Collect ! {reveal, self()},
	receive
		{currentPrime, Candidate} -> case Prime > Candidate of
			true -> revealUntil(Prime, Collect);
			false -> io:format("Found the perfect prime: ~p~n",[Candidate])
			end
	end.



sieve(Prime, PrevSieve) ->
	receive 
		{getPrime, Collect} ->
			Candidate = checkSieve(Prime, PrevSieve),
			NextSieve = spawn(sieve, sieve, [Candidate, self()]),
			Collect ! {prime, Candidate, NextSieve},
			sieve(Prime,PrevSieve);
		{next, From} -> 
			Candidate = checkSieve(Prime, PrevSieve),
			From ! {primeCandidate,Candidate}, sieve(Prime, PrevSieve)
	end.

checkSieve(Prime, PrevSieve) ->
	PrevSieve ! {next, self()},
	receive	
 		{primeCandidate, Candidate} -> 
 			case (Candidate rem Prime) of
 				0 -> checkSieve(Prime, PrevSieve);
 				_ -> Candidate
 			end
	end.
	

allNumbers(Counter) ->
	receive
		{next, From} -> From ! {primeCandidate, Counter}, 
						allNumbers(Counter + 1)
	end.
	
