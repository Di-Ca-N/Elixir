defmodule Pair do
    def cons(a, b), do: fn f -> f.(a, b) end
    def car(pair), do: pair.(fn a, _ -> a end)
    def cdr(pair), do: pair.(fn _, b -> b end)
end

IO.puts Pair.car(Pair.cons(3, 4))
IO.puts Pair.cdr(Pair.cons(3, 4))
