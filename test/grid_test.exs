defmodule EligolGridTest do
  alias Eligol.{Grid,Cell}
  use ExUnit.Case, async: true
  doctest Grid

  test "new grid" do
    width = 64
    height = 128
    grid = Grid.new!(width, height)
    assert grid.width == width
    assert grid.height == height
    assert (grid |> Grid.size) == width * height
  end

  test "coordinate transformation" do
    grid = Grid.new! 3, 4
    for i <- 1..12 do
      {x, y} = Grid.index_to_coords(grid, i)
      assert Grid.coords_to_index(grid, x, y) == i
    end
  end

  test "cell iteration" do
    grid = Grid.new! 100, 200
    for cell <- grid.cells do
      case cell do
        %Cell{} -> nil
        _ -> assert false
      end
    end
  end

  test "cell change" do
    grid = Grid.new! 3, 3
    refute Grid.at(grid, 0, 0).alive
    grid = Grid.set(grid, 0, 0, true)
    assert Grid.at(grid, 0, 0).alive
  end
end
