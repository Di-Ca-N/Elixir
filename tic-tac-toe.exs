# Module with only pure functions, thar manipulates the data structure
defmodule TicTacToe do
    def create_game(), do: { {{nil, nil, nil}, {nil, nil, nil}, {nil, nil, nil}}, :X}

    def play(board, player, row, col) do
        new_row = board |> elem(row) |> put_elem(col, player)
        put_elem(board, row, new_row)
    end

    def change_player(:X), do: :O
    def change_player(:O), do: :X

    def verify_win(board) do
        case board do
            {{x, x, x}, _, _} -> x
            {_, {x, x, x}, _} -> x
            {_, _, {x, x, x}} -> x
            {{x, _, _}, {x, _, _}, {x, _, _}} -> x
            {{_, x, _}, {_, x, _}, {_, x, _}} -> x
            {{_, _, x}, {_, _, x}, {_, _, x}} -> x
            {{x, _, _}, {_, x, _}, {_, _, x}} -> x
            {{_, _, x}, {_, x, _}, {x, _, _}} -> x
            _ -> nil
        end
    end

    def run_game({row, col}, board, player) do
        new_board = board |> play(player, row, col)
        verified_winner = verify_win(new_board)
        next_player = change_player(player)
        {new_board, next_player, verified_winner}
    end
end

# Module responsible for IO and calling the TicTacToe module
defmodule RunGame do
    def run() do
        {board, player} = TicTacToe.create_game()
        do_run(board, player, nil)  
    end

    defp do_run(_, player, winner) when winner != nil do
        winner_player = TicTacToe.change_player(player)
        IO.puts("Jogador #{winner_player} ganhou!")
    end

    defp do_run(board, player, _) do
        IO.puts "What is your play, #{player}?"

        board |> Tuple.to_list()
              |> Enum.map(fn row -> 
                    row |> Tuple.to_list() 
                        |> Enum.map(fn nil -> "   "; item -> " #{item} " end) 
                        |> Enum.join("|") end)
              |> Enum.intersperse("---+---+---")
              |> Enum.join("\n")
              |> IO.puts()
        IO.puts("")
        input = fn message -> IO.gets(message) |> String.trim_trailing() |> String.to_integer() end
        row = input.("Row: ")
        col = input.("Col: ")

        {new_board, next_player, verified_winner} = TicTacToe.run_game({row, col}, board, player)
        do_run(new_board, next_player, verified_winner)
    end
end

RunGame.run()
