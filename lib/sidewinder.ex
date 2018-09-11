defmodule Mazer.Sidewinder do
  alias Mazer.{Cell, Grid}

  def construct(grid) do
    new_grid = Enum.map(grid.grid, fn row ->
      run = []

      Enum.map(row, fn cell ->
        run = [cell | run]

        at_eastern_boundary = cell.east == nil
        at_northern_boundary = cell.north == nil

        should_close_out = at_eastern_boundary ||
        (!at_northern_boundary && Enum.random(0..2) == 0)

        if should_close_out do
          member_cell = random_cell(run)
          north_cell = Grid.neighboring_cell(grid, member_cell, "north")
          if north_cell do
            Cell.link(member_cell, north_cell)
          else
            {:ok, member_cell, north_cell}
          end
        else
          east_cell = Grid.neighboring_cell(grid, cell, "east")
          Cell.link(cell, east_cell)
        end
      end)
    end)
    |> List.flatten
    |> Enum.filter(&(is_tuple(&1)))
    |> update_cells(grid)
  end

  defp random_cell(run) do
    cell = Enum.random(0..length(run) - 1)
    {run_cell, _remainder} = List.pop_at(run, cell)
    run_cell
  end

  defp update_cells([], grid), do: grid
  defp update_cells([{:ok, cell_a, cell_b} | tail], grid) do
    updated_grid = grid
    |> Grid.update_grid_cell(cell_a)
    |> Grid.update_grid_cell(cell_b)

    update_cells(tail, updated_grid)
  end
end
