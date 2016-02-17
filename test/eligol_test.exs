defmodule EligolTest do
  alias Eligol.Grid
  alias Eligol.Cell

  use ExUnit.Case, async: true
  doctest Eligol

  # "setup_all" is called once to setup the case before any test is run
  setup_all do
    :ok
  end

  # "setup" is called before each test is run
  setup do
    :ok
  end

  test "build a grid" do
    width = 64
    height = 128
    grid = Grid.build!(width, height)
    assert grid.width == width
    assert grid.height == height
    assert (grid |> Grid.size) == width * height
  end

  test "coordinate transformation" do
    grid = Grid.build! 3, 4
    for i <- 1..12 do
      {x, y} = Grid.index_to_coords(grid, i)
      assert Grid.coords_to_index(grid, x, y) == i
    end
  end

  test "cell iteration" do
    grid = Grid.build! 100, 200
    for cell <- grid.cells do
      case cell do
        %Cell{} -> nil
        _ -> assert false
      end
    end
  end

  test "cell change" do
    grid = Grid.build! 3, 3
    refute Grid.at(grid, 0, 0).alive
    grid = Grid.set(grid, 0, 0, true)
    assert Grid.at(grid, 0, 0).alive
  end

end
