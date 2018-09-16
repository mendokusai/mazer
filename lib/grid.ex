defmodule Mazer.Grid do
  alias Mazer.{Cell, Grid}

  def init(rows, columns) do
    %{
      rows: rows,
      columns: columns,
      grid: prepare_grid(rows, columns)
    }
  end

  def prepare_grid(rows, columns) do
    1..rows
    |> Enum.map(fn row ->
      Enum.map(1..columns, fn column ->
        Cell.new(row, column)
        |> configure_cell(row, column, rows, columns)
      end)
    end)
  end

  def render(grid) do
    col_lines = Enum.map(1..grid.columns, fn _ -> "---+" end) |> Enum.join("")
    output = "+" <> col_lines
    list = Enum.map(grid.grid, fn row ->
      top = build_row(row, grid)
      bot = build_bottom(row, grid)
      [top, bot]
    end)
    |> List.flatten

    List.flatten([output], list)
    |> Enum.each(&(IO.puts(&1)))
    # "c'est une maze"
    grid
  end

  defp build_row(row, grid), do: build_row(row, grid, "\|")
  defp build_row([], _grid, collection), do: collection
  defp build_row([cell| remainder], grid, collection) do
    east_cell = neighboring_cell(grid, cell, "east")
    east_boundary = if Cell.linked?(cell, east_cell) do
                      " "
                    else
                      "|"
                    end
    updated_collection = collection <> " #{Cell.contents_of(cell)} " <> east_boundary
    build_row(remainder, grid, updated_collection)
  end

  defp build_bottom(row, grid), do: build_bottom(row, grid, "+")
  defp build_bottom([], _grid, collection), do: collection
  defp build_bottom([cell | remainder], grid, collection) do
    south_cell = neighboring_cell(grid, cell, "south")
    south_boundary = if Cell.linked?(cell, south_cell) do
                       "   "
                     else
                       "---"
                     end
    updated_collection = collection <> south_boundary <> "+"
    build_bottom(remainder, grid, updated_collection)
  end

  def neighboring_cell(grid, cell, ord) do
    neighbor = String.to_atom(ord)
    coords = Map.get(cell, neighbor)
    if is_list(coords) do
      [row, col] = coords
      Grid.get_cell(grid, row, col)
    end
  end

  def random_cell(grid) do
    row = Enum.random(1..grid.rows)
    col = Enum.random(1..grid.columns)
    get_cell(grid, row, col)
  end

  def find_cell(grid, cell_name) do
    ~r/row-(?<row>\d)_col-(?<col>\d)/
    |> Regex.named_captures(cell_name)
    |> coerce_cells(grid)
  end

  defp coerce_cells(%{"col" => col, "row" => row}, grid) do
    get_cell(grid, String.to_integer(row), String.to_integer(col))
  end

  def get_cell(%{grid: grid}, row, col) do
    {row, _remainder} = List.pop_at(grid, row - 1)
    {cell, _remainder} = List.pop_at(row, col - 1)
    cell
  end

  def update_grid_cell(grid, nil), do: grid
  def update_grid_cell(grid, cell) do
    {grid_row, _remainder} = List.pop_at(grid.grid, cell.row - 1)

    updated_grid_row = List.replace_at(grid_row, cell.column - 1, cell)

    new_grid = List.replace_at(grid.grid, cell.row - 1, updated_grid_row)
    put_in(grid.grid, new_grid)
  end

  def size(grid), do: grid.rows * grid.columns

  defp configure_cell(cell, row, col, rows, cols) do
    neighbors = %{
      north: set_neighbor(retain_bounds(row, -1, rows), retain_bounds(col,  0, cols)),
      south: set_neighbor(retain_bounds(row,  1, rows), retain_bounds(col,  0, cols)),
      west:  set_neighbor(retain_bounds(row,  0, rows), retain_bounds(col, -1, cols)),
      east:  set_neighbor(retain_bounds(row,  0, rows), retain_bounds(col,  1, cols))
    }
    Map.merge(cell, neighbors)
  end

  defp retain_bounds(elem, adjuster, max) do
    cond do
      elem + adjuster <= 0 -> nil
      elem + adjuster >= max + 1 -> nil
      true -> elem + adjuster
    end
  end

  defp set_neighbor(nil, nil), do: nil
  defp set_neighbor(_val, nil), do: nil
  defp set_neighbor(nil, _val), do: nil
  defp set_neighbor(v1, v2), do: [v1, v2]
end
