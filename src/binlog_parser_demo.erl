%%%----------------------------------------------------------------------------
%%% @private
%%% @doc Demo of binary log parsing in Erlang
%%% @end
%%%----------------------------------------------------------------------------
-module(binlog_parser_demo).

-export([decode/2]).

%%-----------------------------------------------------------------------------
%% @spec decode(LogBinary, Types) -> string()
%% LogBinary = binary()
%% Types = [atom()]
%% @doc
%%   The binary stream is annotated by the list Types. Every call to decode
%%   will look at the type and then pick the proper decode function based on
%%   it. In the case of arrays or strings, the size of the field is given in
%%   the first 32 bits.
%% @end
%%-----------------------------------------------------------------------------
decode(BinLog, Types)
  when is_list(Types) ->
    decode(BinLog, Types, []).

decode(<<>>, []=_Types, Acc) ->
    lists:reverse(Acc);

decode(<<Items:32, String:Items/binary, BinRest/binary>>,
       [string|TypesRest], Acc) ->
    LogMsgSize = Items - 1, %% No need for null terminator, size is known
    <<LogString:LogMsgSize/binary, _NullTerminator:8>> = String,
    decode(BinRest, TypesRest, [binary_to_list(LogString)|Acc]);

decode(<<Items:32, ArrPlusRest/binary>>, [uint8_arr|TypesRest], Acc) ->
    SizeBytes = Items,
    <<Arr:SizeBytes/binary, BinRest/binary>> = ArrPlusRest,
    decode(BinRest, TypesRest, [[Uint8 || <<Uint8:8>> <= Arr]|Acc]);

decode(<<Items:32, ArrPlusRest/binary>>, [uint16_arr|TypesRest], Acc) ->
    SizeBytes = Items * 2,
    <<Arr:SizeBytes/binary, BinRest/binary>> = ArrPlusRest,
    decode(BinRest, TypesRest, [[Uint16 || <<Uint16:16>> <= Arr]|Acc]);

decode(<<Items:32, ArrPlusRest/binary>>, [uint32_arr|TypesRest], Acc) ->
    SizeBytes = Items * 4,
    <<Arr:SizeBytes/binary, BinRest/binary>> = ArrPlusRest,
    decode(BinRest, TypesRest, [[Uint32 || <<Uint32:32>> <= Arr]|Acc]);

decode(<<Uint8:8, BinRest/binary>>, [uint8|TypesRest], Acc) ->
    decode(BinRest, TypesRest, [Uint8|Acc]);

decode(<<Int8:8/signed, BinRest/binary>>, [int8|TypesRest], Acc) ->
    decode(BinRest, TypesRest, [Int8|Acc]);

decode(<<Uint16:16, BinRest/binary>>, [uint16|TypesRest], Acc) ->
    decode(BinRest, TypesRest, [Uint16|Acc]);

decode(<<Int16:16/signed, BinRest/binary>>, [int16|TypesRest], Acc) ->
    decode(BinRest, TypesRest, [Int16|Acc]);

decode(<<Uint32:32, BinRest/binary>>, [uint32|TypesRest], Acc) ->
    decode(BinRest, TypesRest, [Uint32|Acc]);

decode(<<Int32:32/signed, BinRest/binary>>, [int32|TypesRest], Acc) ->
    decode(BinRest, TypesRest, [Int32|Acc]).