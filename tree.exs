defmodule Tree do
    # == Sum code ==
    def sum(x) when is_integer(x), do: x
    def sum([]), do: 0
    def sum([ head | tail ]), do: sum(head) + sum(tail)    

    # == Depth Code ==
    
    # Default depth: 0
    def depth(list, cdepth \\ 0)
    
    # If has no more nested levels, just return the current depth
    def depth(x, cdepth) when is_integer(x), do: cdepth
    def depth([], cdepth), do: cdepth

    # Otherwise, return the max depth between head or tail
    def depth([head | tail], cdepth) do
        [depth(head, cdepth + 1), depth(tail, cdepth)] 
            |> Enum.max
    end

    # == Max Code ==
    def max([]), do: 0
    def max(x) when is_integer(x), do: x
    def max([head|tail]), do: [max(head), max(tail)] |> Enum.max

    
    def flatten([]), do: []
    def flatten(x) when is_integer(x), do: [x]
    def flatten([head|tail]), do: flatten(head) ++ flatten(tail)
    
    def tree_seq(is_branch
    def tree_seq(is_branch, children, tree) when is_branch(tree) do
        tree_seq(is_branch, children, children.(tree))
    end
end

list = [1, [[2], 3], [4], 5, [6, 100, [[7], [[8]], 9]], 10]

IO.puts "A soma é #{Tree.sum(list)}"
IO.puts "A profundidade é #{Tree.depth(list)}"
IO.puts "O maior elemento é #{Tree.max(list)}"
IO.inspect Tree.flatten(list)
IO.inspect Tree.tree_seq(&is_list/1, fn a -> a end, [1, [2, [3, 5]]])
