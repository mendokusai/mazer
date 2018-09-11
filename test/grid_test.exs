defmodule Mazer.Grid.Test do
  use ExUnit.Case
  alias Mazer.{Cell, Grid}

  describe "init" do
    test "creates a grid of cells" do
      grid = Grid.init(2, 2)
      assert grid.rows == 2
      assert grid.columns ==  2

      assert grid.grid == [
        [
          %{
            column: 1,
            east: [1, 2],
            links: %{},
            name: "row-1_col-1",
            row: 1,
            south: [2, 1],
            north: nil,
            west: nil
            },
          %{
            column: 2,
            links: %{},
            name: "row-1_col-2",
            row: 1,
            south: [2, 2],
            west: [1, 1],
            east: nil,
            north: nil
          }
        ],
        [
          %{column: 1, east: [2, 2], links: %{}, name: "row-2_col-1", north: [1, 1], row: 2, south: nil, west: nil},
          %{column: 2, links: %{}, name: "row-2_col-2", north: [1, 2], row: 2, west: [2, 1], east: nil, south: nil}
        ]
      ]
    end
  end
end
