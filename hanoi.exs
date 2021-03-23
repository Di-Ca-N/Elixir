defmodule Hanoi do
    def solve(from, to, through, quantity)
    def solve(_, _, _, 0), do: []
    def solve(from, to, through, quantity) do
        solve(from, through, to, quantity - 1) ++ 
        ["Move disk from #{from} to #{to}"] ++ 
        solve(through, to, from, quantity - 1) 
    end
end

Hanoi.solve("A", "C", "B", 6) 
    |> Enum.each(fn (s) -> IO.puts(s) end)

