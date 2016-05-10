#[Swap Nodes](https://www.hackerrank.com/challenges/swap-nodes)

This problem is pretty straight forward. However, it took me a couple of tries to get it right.
I think it's because I'm still getting used to some of the functional programming concepts.

I'll try to explain what was my line of thought when I tried to solve this problem and the problems with them.

## Data Structure

I think the first think I got wrong was the basic data structure to build the tree. This was the first one I did.

```erlang
-type tree() :: {node, Val::any(), nil, nil}
                | {node, Val::any(), Left::tree(), Right::tree()}
                | {node, Val::any(), nil, Right::tree()}
                | {node, Val::any(), Left::tree(), nil}.
```

As you can see the tree is a tuple where the first item is the symbol ``` node ```, a value that could be anything, and two subtrees, left and right subtree. These subtrees could also be a binary tree or an empty tree. As you can see he definition is altrady pretty verbose because I have to cover all the possible permutation of subtree between a tree and an empty tree. This made all my code more complex. So I re factor it to the following data structure.

```erlang
-type tree() :: empty
               | {node, Val::tree(), Val::tree()}.
```

As you can see this definition looks way simpler and makes look you code simpler too.

## Access to your data structure

Other mistake I did was to abuse pattern matching to get the values of my data structure. Which also made the code harder to reason about. I guess as this is a simple competitive programming exercise I wasn't thinking on the readability of my code. However, as soon I had to debug my code it was super hard and I lost all the declarative expressiveness that FP provides. Also, if I'm using this problem to improve my functional programming skills It's better to follow best practices.

```erlang
swap_tree({node, Val, Left, Right}, Level, H, I, Current) when Current < Level ->
```

After cleaning the code

```erlang
swap_tree(Tree, Level, Current) when Current rem Level =:= 0
```

## Conclusion

Think hard about the data structure you're using before jumping stright to the code.
Keep your code declarative, if you're code is getting to complex, tkae a step back and think how you can make it simpler



