defmodule Sudoku do
    def solve(sudoku), do: solve(sudoku, 0, 0)

    def solve(sudoku, 9, 0), do: {:success, sudoku}

    def solve(sudoku, row, col) do
        valid = sudoku |> validate(:partial)

        if valid do
            element = sudoku |> Enum.at(row) |> Enum.at(col)
            next_col = rem(col + 1, 9)
            next_row = if next_col == col + 1, do: row, else: row + 1
            
            if element == 0 do
                solve_for_number = fn number ->
                    sudoku |> replace(row, col, number)
                           |> solve(next_row, next_col)
                end

                success_solution = fn 
                    {:success, _} -> true
                    {:failure, _} -> false
                end

                1..9 |> Enum.map(solve_for_number)
                     |> Enum.find({:failure, :unsolvable}, success_solution)
            else
                solve(sudoku, next_row, next_col)
            end
        else
            {:failure, :unsolvable}
        end
    end
    
    def validate(sudoku, mode \\ :complete) do
        valid_rows = sudoku |> rows() 
                            |> all_valid?(mode)
        valid_cols = sudoku |> cols()
                            |> all_valid?(mode)
        valid_blocks = sudoku |> blocks()
                              |> all_valid?(mode)
        valid_rows and valid_cols and valid_blocks
    end

    defp all_valid?(list, mode), do: Enum.all?(list, &(valid_chunk?(&1, mode)))

    defp valid_chunk?(chunk, :complete) do
        chunk |> Enum.uniq() 
              |> length() == length(chunk)
    end

    defp valid_chunk?(chunk, :partial) do
        chunk |> Enum.filter(& (&1 != 0))
              |> valid_chunk?(:complete)
    end
    
    defp rows(sudoku), do: sudoku

    defp cols(sudoku) do
        sudoku |> Enum.zip() 
               |> Enum.map(&Tuple.to_list/1) 
    end

    defp blocks(sudoku) do
        sudoku |> Enum.flat_map(&Enum.chunk_every(&1, 3))
               |> Enum.with_index()
               |> Enum.group_by(&rem(elem(&1, 1), 3), &elem(&1, 0))
               |> Map.values()
               |> List.flatten()
               |> Enum.chunk_every(9)
    end

    defp replace(sudoku, row, col, new_element) do
        new_line = sudoku |> Enum.at(row) 
                          |> List.replace_at(col, new_element)
        sudoku |> List.replace_at(row, new_line)
    end
end

# Examples:
#    1 3 2 5 7 9 4 6 8
#    4 9 8 2 6 1 3 7 5
#    7 5 6 3 8 4 2 0 9
#    6 4 3 1 5 8 7 9 2
#    5 2 1 7 9 3 8 4 6
#    9 8 7 4 2 6 5 3 1
#    2 1 4 9 3 5 6 0 7
#    3 6 5 8 1 7 9 2 4
#    8 7 9 6 4 2 1 5 3
#



#    5 3 0 0 7 0 0 0 0
#    6 0 0 1 9 5 0 0 0
#    098000060]
#    800060003]
#    400803001]
#    700020006]
#    060000280]
#    000419005]
#    000080079]



get_board = fn message ->
    IO.puts(message)
    
    0..8 |> Enum.map(fn _ -> 
        IO.gets("") |> String.trim()
                    |> String.split()
                    |> Enum.map(&String.to_integer/1)
        end
    )
end


board = get_board.("Input your sudoku: ")

case Sudoku.solve(board) do
    {:success, solution} -> 
        IO.puts("Solution found!")
        solution |> Enum.map(&(Enum.join(&1, " ")))
                 |> Enum.each(&IO.puts/1)
    {:failure, _} -> IO.puts("There is no solution =(")
end

