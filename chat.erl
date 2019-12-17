-module(chat).
-export([join/1, sendMessage/2, server/0]).

join(Client) ->
    %Host = "localhost", % to make it runnable on one machine
    {ok, Sock} = gen_tcp:connect("localhost", 4000,  [binary, {packet, 0}]),
    ok = gen_tcp:send(Sock, Client ++ ": " ++"Bonjour"),
    ok = gen_tcp:close(Sock).

sendMessage(Client, Message) ->
    %Host = "localhost", % to make it runnable on one machine
    {ok, Sock} = gen_tcp:connect("localhost", 4000,  [binary, {packet, 0}]),
    ok = gen_tcp:send(Sock, Client ++ ": " ++Message),
    ok = gen_tcp:close(Sock).


server() ->
    {ok, ListenSock} = gen_tcp:listen(4000, [binary, {packet, 0}, {active, false}]),
    {ok, Sock} = gen_tcp:accept(ListenSock),
    {ok, Bin} = do_recv(Sock, []),
    ok = gen_tcp:close(Sock),
    ok = gen_tcp:close(ListenSock), Bin.

do_recv(Sock, Bs) ->
    case gen_tcp:recv(Sock, 0) of
        {ok, B} ->
            do_recv(Sock, [Bs, B]);
        {error, closed} ->
            {ok, list_to_binary(Bs)}
    end.
