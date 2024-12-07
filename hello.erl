-module(hello_server).
-export([start/0, init/2, handle/2, terminate/3, code_change/3]).

start() ->
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/hello", ?MODULE, []}
        ]}
    ]),
    {ok, _} = cowboy:start_clear(my_http_listener, 100, #{port => 8080}, #{
        env => #{dispatch => Dispatch}
    }),
    io:format("Server started at http://localhost:8080/~n").

init(Req, State) ->
    {cowboy_rest, Req, State}.

handle(Req, State) ->
    Method = cowboy_req:method(Req),
    case Method of
        <<"POST">> ->
            {ok, Req2} = cowboy_req:reply(200, #{<<"content-type">> => <<"text/plain">>}, <<"Hello there">>, Req),
            {ok, Req2, State};
        _ ->
            {ok, Req2} = cowboy_req:reply(405, #{<<"content-type">> => <<"text/plain">>}, <<"Method Not Allowed">>, Req),
            {ok, Req2, State}
    end.

terminate(_Reason, _Req, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
