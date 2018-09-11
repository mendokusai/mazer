defmodule Mazer.Cell do
  use Ecto.Schema
  @coordinates [:north, :south, :east, :west]

  def new(row, column) do
    %{
      name: "row-#{row}_col-#{column}",
      row: row,
      column: column,
      links: %{}
    }
  end

  def link(cell, linking_cell, bidi \\ true) do
    cell_a = link_cell(cell, linking_cell, true)
    cell_b = if bidi do
      link_cell(linking_cell, cell, false)
    else
      linking_cell
    end
    {:ok, cell_a, cell_b}
  end

  def unlink(cell, linking_cell, bidi \\ true) do
    cell_a = unlink_cells(cell, linking_cell, bidi)
    cell_b = if bidi do
      unlink_cells(linking_cell, cell, bidi)
    else
      linking_cell
    end
    {:ok, cell_a, cell_b}
  end

  def links(cell) do
    Map.keys(cell.links)
    |> Enum.map(&(Atom.to_string(&1)))
  end

  def linked?(_cell, nil), do: false
  def linked?(nil, _cell), do: false
  def linked?(cell_a, cell_b) do
    Map.has_key?(cell_a.links, String.to_atom(cell_b.name))
  end

  def neighbors(cell) do
    Enum.filter(@coordinates, &(Map.get(cell, &1)))
  end

  defp unlink_cells(cell_a, cell_b, _direction) do
    links = Map.delete(cell_a.links, String.to_atom(cell_b.name))
    put_in(cell_a.links, links)
  end

  defp link_cell(cell_a, cell_b, direction) do
    links = Map.merge(cell_a.links, %{"#{cell_b.name}":  direction})
    put_in(cell_a.links, links)
  end
end
