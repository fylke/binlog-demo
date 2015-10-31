%%%----------------------------------------------------------------------------
%%% @private
%%% @doc Test {@link binlog_parser_demo}.
%%% @end
%%%----------------------------------------------------------------------------
-module(binlog_parser_demo_tests).
-include_lib("eunit/include/eunit.hrl").

decode_FLEXIBLE_test() ->
    ["apanap"] =
        binlog_parser_demo:decode(<<7:32,$a,$p,$a,$n,$a,$p,0>>, [string]),
    ok.

decode_UINT8_test() ->
    [16#ab] = binlog_parser_demo:decode(<<16#ab>>, [uint8]),
    ok.

decode_INT8_test() ->
    [-17] = binlog_parser_demo:decode(<<16#ef>>, [int8]),
    [-16#11] = binlog_parser_demo:decode(<<16#ef>>, [int8]),
    ok.

decode_UINT16_test() ->
    [16#abcd] = binlog_parser_demo:decode(<<16#ab,16#cd>>, [uint16]),
    ok.

decode_INT16_test() ->
    [-1234] = binlog_parser_demo:decode(<<16#fb,16#2e>>, [int16]),
    ok.

decode_UINT32_test() ->
    [16#abcdefba] =
        binlog_parser_demo:decode(<<16#ab,16#cd,16#ef,16#ba>>, [uint32]),
    ok.

decode_INT32_test() ->
    [-1234000] =
        binlog_parser_demo:decode(<<16#ff,16#ed,16#2b,16#b0>>, [int32]),
    ok.

decode_UINT8_ARR_test() ->
    [[16#ab, 16#cd, 16#ef, 16#ba]] =
        binlog_parser_demo:decode(<<4:32,16#ab,16#cd,16#ef,16#ba>>,
                                  [uint8_arr]),
    ok.

decode_UINT16_ARR_test() ->
    [[16#abcd, 16#efba]] =
        binlog_parser_demo:decode(<<2:32,16#ab,16#cd,16#ef,16#ba>>,
                                  [uint16_arr]),
    ok.

decode_UINT32_ARR_test() ->
    [[16#abcdefba]] =
        binlog_parser_demo:decode(<<1:32,16#ab,16#cd,16#ef,16#ba>>,
                                  [uint32_arr]),
    ok.

decode_decimal_test() ->
    [1, 2, 3] =
        binlog_parser_demo:decode(<<1:8,2:16,3:32>>, [uint8, uint16, uint32]),
    ok.

decode_event_base_test() ->
    [16#abcd, [16#ab, 16#cd, 16#ef, 16#ba]] =
        binlog_parser_demo:decode(<<16#ab,16#cd,4:32,16#ab,16#cd,16#ef,16#ba>>,
                                  [uint16, uint8_arr]),
    ok.