-module(solution).
-export([main/0]).
  % -include_lib("eunit/include/eunit.hrl").


-type tree() :: {node, Val::any(), nil, nil}
                | {node, Val::any(), Left::tree(), Right::tree()}
                | {node, Val::any(), nil, Right::tree()}
                | {node, Val::any(), Left::tree(), nil}.

-spec new_tree(integer()) -> tree().
new_tree(Val) ->
    {node, Val, nil, nil}.

-spec add_children(tree(), integer(), integer()) -> tree().
add_children(Tree, -1, -1) ->
    Tree;
add_children({node, Val, nil, nil}, -1, Right) ->
    {node, Val, nil, new_tree(Right)};
add_children({node, Val, nil, nil}, Left, -1) ->
    {node, Val, new_tree(Left), nil};
add_children({node, Val, nil, nil}, Left, Right) ->
    {node, Val, new_tree(Left), new_tree(Right)}.

main() ->
    {ok,  [Num]} = io:fread("", "~d"),
    {Tree, H} = map_to_tree(read_tree2(Num - 1, [1], #{})),
    % ?debugVal(H),

    {ok,  [Ops]} = io:fread("", "~d"),
    swap(Tree, H, Ops).
    % init:stop().

    % [io:format("~p ", [X]) || X <- Output],
    % io:format("~n", []).

swap(Tree, _H, 0) ->
    Tree;
swap(Tree, H, Ops) ->
    {ok,  [Level]} = io:fread("", "~d"),
    Tree1 = swap_tree(Tree, Level, H, 1, 1),


    Output = print_tree(Tree1, []),
    [io:format("~p ", [X]) || X <- Output],
    io:format("~n", []),
    swap(Tree1, H, Ops -1).

swap_tree(nil, _Level, _H, _I, _Current)  ->
    nil;
swap_tree({node, Val, Left, Right}, Level, H, I, Current) when Current < Level ->
    Left1 = swap_tree(Left, Level, H, I, Current + 1),
    Right1 = swap_tree(Right, Level, H, I, Current + 1),
    {node, Val, Left1, Right1};
swap_tree({node, Val, Left, Right}, Level, H, I, Current) when Current >= Level ->
    case (I+1)*Level =< H of
        true ->  swap_tree({node, Val, Right, Left}, (I+1)*Level, H, I+1, Current);
        false -> {node, Val, Right, Left}
    end.

read_tree2(_Level, [], Map) ->
    Map;
read_tree2(Level, [Node | Rest], Map) ->
    % ?debugVal(List),
    {ok,  [Left, Right]} = io:fread("", "~d ~d"),
    Map1 = maps:put(Node, [Left, Right], Map),
    read_tree2(Level - 1, [X || X <- Rest ++ [Left, Right], X > 0], Map1).


node_value({node, Val, _Left, _Right}) ->
    Val.

map_to_tree(Map) ->
    map_to_tree(Map, new_tree(1), 1).

map_to_tree(_Map, nil, H) ->
    {nil, H-1};
map_to_tree(Map, Node, H) ->
    [Left, Right] = maps:get(node_value(Node), Map, [-1, -1]),
    {node, Val, Left1, Right1} = add_children(Node, Left, Right),
    {Left2, H1} = map_to_tree(Map, Left1, H + 1),
    {Right2, H2} = map_to_tree(Map, Right1, H + 1),
    {{node, Val, Left2, Right2}, max(H1, H2)}.

% -spec read_tree(integer(), tree()) -> tree().
% read_tree(0, Tree) ->
%     Tree;
% read_tree(_Level, nil) ->
%     nil;
% read_tree(Level, [Node | Rest]) ->
%     {ok,  [Left, Right]} = io:fread("", "~d ~d"),
%     {node, Val, Left1, Right1} = add_children(Node, Left, Right),
%     Left2 = read_tree(Level - 1, Left1),
%     Right2 = read_tree(Level - 1, Right1),
%     {node, Val, Left2, Right2}.

print_tree({node, Val, nil, nil}, Output) ->
    Output ++ [Val];
print_tree({node, Val, nil, Right}, Output) ->
    Output1 = Output ++ [Val],
    print_tree(Right, Output1);
print_tree({node, Val, Left, nil}, Output) ->
    Output1 = print_tree(Left, Output),
    Output1 ++ [Val];
print_tree({node, Val, Left, Right}, Output) ->
    Output1 = print_tree(Left, Output),
    Output2 = Output1 ++ [Val],
    print_tree(Right, Output2).
