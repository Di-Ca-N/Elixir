defmodule Take do
    def take(0, _), do: []
    def take(quantity, [head|tail]), do: [head] ++ take(quantity - 1, tail)

    def drop(0, seq), do: seq
    def drop(quantity, [_|tail]), do: drop(quantity - 1, tail)
end

IO.inspect Take.take(3, [1,2,3,4,5,6,7,8,9])
IO.inspect Take.drop(3, [1,2,3,4,5,6])
