-module(solution).
-export([main/0]).

%-include_lib("eunit/include/eunit.hrl").

-type tree() :: empty | {node, integer(), tree(), tree()}.

node_value({node, Val, _Left, _Right}) ->
  Val.

right_node({node, _Val, _Left, Right}) ->
  Right.
left_node({node, _Val, Left, _Right}) ->
  Left.

new_node(Val) ->
  {node, Val, empty, empty}.

empty_node() ->
  empty.

main() ->
  {ok,  [Cases]} = io:fread("", "~d"),
  cases(Cases),
  ok.

-spec cases(integer()) -> ok.
cases(0) ->
  ok;
cases(N) ->
  {ok,  [Nodes]} = io:fread("", "~d"),
  LineTuple =  [io:fread("", "~d") || _ <- lists:seq(1, Nodes)],
  Line = [X || {ok, [X]} <- LineTuple ],
  Tree = line_to_tree(Line, empty_node()),
  %?debugVal(tree_to_line(Tree)),
  %?debugVal(Line),
  case tree_to_line(Tree) =:= Line of
    false ->
      io:format("NO~n", []);
    true ->
      io:format("YES~n", [])
  end,
  cases(N-1),
  ok.

tree_to_line(empty ) ->
  [];
tree_to_line(Tree) ->
  [node_value(Tree)] ++ tree_to_line(left_node(Tree)) ++ tree_to_line(right_node(Tree)).

line_to_tree([Head|Tail], Tree) ->
  Tree1 = insert(Tree, Head),
  line_to_tree(Tail, Tree1);
line_to_tree([], Tree) ->
  Tree.


insert(empty, Val) ->
  new_node(Val);
insert({Node, Value, Left, Right}, Val) when Value > Val ->
  {Node, Value, insert(Left, Val), Right};
insert({Node, Value, Left, Right}, Val) when Value < Val ->
  {Node, Value, Left, insert(Right, Val)}.



