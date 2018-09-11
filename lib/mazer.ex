defmodule Mazer do
  alias Mazer.{BinaryTree, Grid, Sidewinder}
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
end
