defmodule Mazer.Distances do
  def generate(cell) do
    %{
      root: cell,
      cells: %{String.to_atom(cell.name) => %{cell: cell, distance: 0}}
    }
  end

  def cell_distance(distances, cell) when is_atom(cell) do
    if has_cell?(distances, cell) do
      Map.fetch!(distances.cells, cell)
    end
  end

  def cell_distance(distances, cell) do
    if has_cell?(distances, cell) do
      Map.fetch!(distances.cells, name_of(cell))
    end
  end

  def set_cell(distances, cell, distance) do
    new_cells = add_cell(distances.cells, cell, distance)
    put_in(distances.cells, new_cells)
  end

  def cells(distances) do
    Map.keys(distances.cells)
  end

  def has_cell?(distances, cell) when is_map(cell) do
    Map.has_key?(distances.cells, name_of(cell))
  end

  def has_cell?(distances, cell) when is_atom(cell) do
    Map.has_key?(distances.cells, cell)
  end

  defp add_cell(cells, cell, distance) when is_map(cell) do
    Map.merge(cells, %{name_of(cell) => %{cell: cell, distance: distance}})
  end
  #
  # defp add_cell(cells, cell, distance) when is_atom(cell) do
  #   cell =
  #   Map.merge(cells, %{cell => distance})
  # end

  defp name_of(%{name: name}), do: String.to_atom(name)
end
