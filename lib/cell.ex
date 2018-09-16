defmodule Mazer.Cell do
  alias Mazer.Distances

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

  def contents_of(cell, distances \\ %{})
  def contents_of(_cell, %{}), do: " "
  def contents_of(cell, distances) do
    Distances.cell_distance(distances, cell)
  end

  def distances(cell) do
    [String.to_atom(cell.name)]
    |> crawl_links(Distances.generate(cell))
  end

  def crawl_links([], distances), do: distances
  def crawl_links([cell| remainder], distances) do
    neighboring_cells = viable_cell_links(cell)

    new_distances = neighboring_cells
    |> update_distances(distances)

    List.flatten(remainder, neighboring_cells)
    |> crawl_links(new_distances)
  end

  defp update_distances([], distances), do: distances
  defp update_distances([cell_name | remainder], distances) do
    if Distances.has_cell?(distances, cell_name) do
      update_distances(remainder, distances)
    else
      # problem here is that if the cell doesn't exist, it's hard to add a distance...
      distance = first_neighbor_distance(distances, cell_name) + 1
      # distance = Distances.cell_distance(distances, cell_name) |> IO.inspect(label: "dist")
      # distance = distance + 1
      new_distances = Distances.set_cell(distances, cell_name, distance)
      update_distances(remainder, new_distances)
    end
  end

  defp first_neighbor_distance(distances, cell_atom) do
    cell_name = Atom.to_string(cell_atom)
    Map.to_list(distances.cells)
    |> Enum.map(fn {_name, map} -> map.distance end)
    |> Enum.max
  end

  defp viable_cell_links(%{links: links}) do
    Map.to_list(links)
    |> Enum.filter(fn {_name, bool} -> bool == true end)
    |> Enum.map(fn {name, _bool} -> name end)
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
