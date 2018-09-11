defmodule Mazer.BinaryTree do
  alias Mazer.{Cell, Grid}
  @ordinates [:north, :east]

  def construct(grid) do
    Enum.map(grid.grid, fn row ->
      Enum.map(row, fn cell ->
        neighbors = @ordinates
        |> Enum.map(&(Map.get(cell, &1)))
        |> Enum.filter(&(is_list(&1)))

        if length(neighbors) > 0 do
          index = Enum.random(1..length(neighbors))

          {[neighbor_row, neighbor_col], _remainder} = List.pop_at(neighbors, index - 1)

          neighbor_cell = Grid.get_cell(grid, neighbor_row, neighbor_col)

          if neighbor_cell do
            Cell.link(cell, neighbor_cell)
          else
            {:ok, cell, neighbor_cell}
          end
        end
      end)
    end)
    |> List.flatten
    |> Enum.filter(&(is_tuple(&1)))
    |> update_cells(grid)
  end

  defp update_cells([], grid), do: grid
  defp update_cells([{:ok, cell_a, cell_b} | tail], grid) do
    updated_grid = grid
    |> Grid.update_grid_cell(cell_a)
    |> Grid.update_grid_cell(cell_b)

    update_cells(tail, updated_grid)
  end
end
