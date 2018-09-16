defmodule Mazer do
  alias Mazer.{BinaryTree, Cell, Distances, Grid, Sidewinder}
  @moduledoc """
  Documentation for Mazer.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Mazer.hello
      :world

  """
  def binary_tree(rows \\ 4, cols \\ 4) do
    Grid.init(rows, cols)
    |> BinaryTree.construct
    |> Grid.render
  end

  def sidewinder(rows \\ 4, cols \\ 4) do
    Grid.init(rows, cols)
    |> Sidewinder.construct
    |> Grid.render
  end

  def dijkstra(rows \\ 4, cols \\ 4) do
    maze = Grid.init(rows, cols)
    |> BinaryTree.construct
    |> Grid.render

    start = Grid.get_cell(maze, 1, 1)
    distances = Distances.generate(start)
    Cell.crawl_links([start], distances) |> IO.inspect(label: "distances?")
  end
end
