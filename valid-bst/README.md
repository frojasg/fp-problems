#[Valid BST](https://www.hackerrank.com/challenges/valid-bst)

This Problem it's pretty similar to [Swap Nodes](../swap-node/README.md). The only difference is that you have to build a tree using the BST rules. I used the following code to insert numbers to the tree. I'm not sure what you think this code it's pretty declarative and you can understand the intent right away.

```erlang
insert(empty, Val) ->
  new_node(Val);
insert({Node, Value, Left, Right}, Val) when Value > Val ->
  {Node, Value, insert(Left, Val), Right};
insert({Node, Value, Left, Right}, Val) when Value < Val ->
  {Node, Value, Left, insert(Right, Val)}.
```

If you try to insert a value that already exist in the tree you will get an exception because that case can't be matched in our pattern matching. If that happens it means there's a violation in the problem definition or we messed up in some part of the code. As matter of fact, I had a problem in my code where I was reading one more value I should have to and I was able to find it right away because of this.

I also wrote a function to transform a Tree into a list using the ``` Preorder``` traversal. At the beginning, I wrote that function using a Tail-Recursive function. I always keep forgetting that in Erlang [Tail-Recursive functions are ___NOT___ faster than recursive functions](http://erlang.org/doc/efficiency_guide/myths.html#id60476).

This is how that function looks like:
```erlang
tree_to_line(empty ) ->
  [];
tree_to_line(Tree) ->
  [node_value(Tree)] ++ tree_to_line(left_node(Tree)) ++ tree_to_line(right_node(Tree)).
```

