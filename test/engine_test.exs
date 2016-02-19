defmodule EligolEngineTest do
  alias Eligol.{Engine,Grid}
  use ExUnit.Case, async: true
  doctest Engine

  test "blinker" do
    states = [
      [ [0, 0, 0],
        [1, 1, 1],
        [0, 0, 0] ],
      [ [0, 1, 0],
        [0, 1, 0],
        [0, 1, 0] ]
    ]

    grids = states |> Enum.map(&Grid.new!/1)
    assert Engine.step(grids |> Enum.at(0)) == grids |> Enum.at(1)
    assert Engine.step(grids |> Enum.at(1)) == grids |> Enum.at(0)
  end

  test "still lifes" do
    states = [ [ [0, 0, 0, 0, 0, 0],
                 [0, 0, 1, 1, 0, 0],
                 [0, 1, 0, 0, 1, 0],
                 [0, 0, 1, 1, 0, 0],
                 [0, 0, 0, 0, 0, 0] ],
               [ [0, 0, 0, 0],
                 [0, 1, 1, 0],
                 [0, 1, 1, 0],
                 [0, 0, 0, 0] ],
               [ [0, 0, 0, 0, 0],
                 [0, 0, 1, 0, 0],
                 [0, 1, 0, 1, 0],
                 [0, 0, 1, 0, 0],
                 [0, 0, 0, 0, 0] ] ]
    for state <- states do
      grid = Grid.new! state
      assert Engine.step(grid) == grid
    end
  end

  test "glider with wrap" do
    states = [ [ [0, 0, 0, 0, 0],
                 [0, 0, 1, 0, 0],
                 [0, 0, 0, 1, 0],
                 [0, 1, 1, 1, 0],
                 [0, 0, 0, 0, 0] ],
               [ [0, 0, 0, 0, 0],
                 [0, 0, 0, 0, 0],
                 [0, 1, 0, 1, 0],
                 [0, 0, 1, 1, 0],
                 [0, 0, 1, 0, 0] ],
               [ [0, 0, 0, 0, 0],
                 [0, 0, 0, 0, 0],
                 [0, 0, 0, 1, 0],
                 [0, 1, 0, 1, 0],
                 [0, 0, 1, 1, 0] ],
               [ [0, 0, 0, 0, 0],
                 [0, 0, 0, 0, 0],
                 [0, 0, 1, 0, 0],
                 [0, 0, 0, 1, 1],
                 [0, 0, 1, 1, 0] ],
               [ [0, 0, 0, 0, 0],
                 [0, 0, 0, 0, 0],
                 [0, 0, 0, 1, 0],
                 [0, 0, 0, 0, 1],
                 [0, 0, 1, 1, 1] ],
               [ [0, 0, 0, 1, 0],
                 [0, 0, 0, 0, 0],
                 [0, 0, 0, 0, 0],
                 [0, 0, 1, 0, 1],
                 [0, 0, 0, 1, 1] ],
              ]
    grids = states |> Enum.map(&Grid.new!/1)
    for [s1, s2] <- grids |> Stream.cycle
                          |> Stream.chunk(2, 1)
                          |> Stream.take(length(states) - 1) do
      assert Engine.step(s1, edges: :wrap) == s2
    end
  end
end
