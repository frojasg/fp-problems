-module(solution).
-export([main/0]).

-type tree() :: empty
               | {node, Val::tree(), Val::tree()}.

-spec new_tree(integer()) -> tree().
new_tree(-1) ->
    empty;
new_tree(Val) ->
    {node, Val, empty, empty}.

-spec add_children(tree(), integer(), integer()) -> tree().
add_children(empty, _Left, _Right) ->
    empty;
add_children(Node, Left, Right) ->
    {node, node_value(Node), new_tree(Left), new_tree(Right)}.

-spec replace_children(tree(), tree(), tree()) -> tree().
replace_children(Node, Left, Right) ->
  {node, node_value(Node), Left, Right}.

node_value({node, Val, _Left, _Right}) ->
    Val.

right_node({node, _Val, _Left, Right}) ->
  Right.

left_node({node, _Val, Left, _Right}) ->
  Left.

main() ->
    {ok,  [Num]} = io:fread("", "~d"),
    {Tree, H} = map_to_tree(read_tree(Num - 1, [1], #{})),

    {ok,  [Ops]} = io:fread("", "~d"),
    swap(Tree, H, Ops).

swap(Tree, _H, 0) ->
    Tree;
swap(Tree, H, Ops) ->
    {ok,  [Level]} = io:fread("", "~d"),
    Tree1 = swap_tree(Tree, Level, 1),
    Output = print_tree(Tree1, []),
    [io:format("~p ", [X]) || X <- Output],
    io:format("~n", []),
    swap(Tree1, H, Ops -1).

swap_tree(empty, _Level, _Current) ->
  empty;
swap_tree(Tree, Level, Current) when Current rem Level =:= 0  ->
  Left = swap_tree(left_node(Tree), Level, Current+1),
  Right = swap_tree(right_node(Tree), Level, Current+1),
  replace_children(Tree, Right, Left);
swap_tree(Tree, Level, Current) when Current rem Level =/= 0  ->
  Left = swap_tree(left_node(Tree), Level, Current+1),
  Right = swap_tree(right_node(Tree), Level, Current+1),
  replace_children(Tree, Left, Right).

read_tree(_Level, [], Map) ->
    Map;
read_tree(Level, [Node | Rest], Map) ->
    {ok,  [Left, Right]} = io:fread("", "~d ~d"),
    Map1 = maps:put(Node, [Left, Right], Map),
    read_tree(Level - 1, [X || X <- Rest ++ [Left, Right], X > 0], Map1).

map_to_tree(Map) ->
    map_to_tree(Map, new_tree(1), 1).

map_to_tree(_Map, empty, H) ->
    {empty, H-1};
map_to_tree(Map, Node, H) ->
    [Left, Right] = maps:get(node_value(Node), Map, [-1, -1]),
    {node, Val, Left1, Right1} = add_children(Node, Left, Right),
    {Left2, H1} = map_to_tree(Map, Left1, H + 1),
    {Right2, H2} = map_to_tree(Map, Right1, H + 1),
    {{node, Val, Left2, Right2}, max(H1, H2)}.

print_tree(empty, Output) ->
    Output;
print_tree(Tree, Output) ->
  Output1 = print_tree(left_node(Tree), Output),
  Output2 = Output1 ++ [node_value(Tree)],
  print_tree(right_node(Tree), Output2).

