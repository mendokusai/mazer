defmodule Mazer.Cell.Test do
  use ExUnit.Case
  alias Mazer.{Cell, Grid}

  setup do
    cell_a = Cell.new(1,1)
    cell_b = Cell.new(2,6)

    {:ok, cell_a: cell_a, cell_b: cell_b}
  end
  describe "new" do
    test "creates a map for a cell", %{cell_a: cell_a} do
      assert %{
        name: "row-1_col-1",
        row: 1,
        column: 1,
        links: %{}
      } == cell_a
    end
  end

  describe "link" do
    test "links two cells", %{cell_a: cell_a, cell_b: cell_b} do
      assert {
        :ok,
        %{column: 1, links: %{"row-2_col-6": true}, name: "row-1_col-1", row: 1},
        %{column: 6, links: %{"row-1_col-1": false}, name: "row-2_col-6", row: 2}
      } == Cell.link(cell_a, cell_b, true)
    end
  end

  describe "unlink" do
    test "unlink two cells", %{cell_a: cell_a, cell_b: cell_b} do
      cell_a_1 = put_in(cell_a.links, %{"row-2_col-6": true})
      cell_b_2 = put_in(cell_b.links, %{"row-1_col-1": false})

      assert {:ok, cell_a, cell_b} == Cell.unlink(cell_a_1, cell_b_2, true)
    end
  end

  describe "links" do
    test "returns links for a cell", %{cell_a: cell_a, cell_b: cell_b} do
      {:ok, a, b} = Cell.link(cell_a, cell_b, true)

      assert ["row-2_col-6"] == Cell.links(a)
      assert ["row-1_col-1"] == Cell.links(b)
    end

    test "returns links for a linked cell with false", %{cell_a: cell_a, cell_b: cell_b} do
      {:ok, a, b} = Cell.link(cell_a, cell_b, false) # false means it doesnt link the second
      assert ["row-2_col-6"] == Cell.links(a)
      assert [] == Cell.links(b)
    end
  end

  describe "linked?" do
    test "returns true if two cells are linked", %{cell_a: cell_a, cell_b: cell_b} do
      {:ok, cell_a, cell_b} = Cell.link(cell_a, cell_b, true)

      assert true == Cell.linked?(cell_a, cell_b)
    end

    test "returns false if two cells are not linked", %{cell_a: cell_a, cell_b: cell_b} do
      assert false == Cell.linked?(cell_a, cell_b)
    end

    test "returns false with undefined cell", %{cell_a: cell_a, cell_b: cell_b} do
      assert_raise UndefinedFunctionError, fn -> Cell.linked?(cell_a, nil) end
    end
  end

  describe "neighbors" do
    test "returns a list of neighbor ordinates for a cell" do
      cell = %{
        column: 1,
        east: [2, 2],
        links: %{},
        name: "row-2_col-1",
        north: nil,
        row: 2,
        south: nil,
        west: [2, 0]
      }

      assert [:east, :west] == Cell.neighbors(cell)
    end
  end
end
