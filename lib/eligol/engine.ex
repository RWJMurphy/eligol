defmodule Eligol.Engine do
  alias Eligol.{Cell,Grid}
  # things i need
  # - a grid / world
  # - a cell
  #   - alive | dead
  # - what do on edge (live, dead, wrap)
  @spec step(%Eligol.Grid{}) :: {:ok, %Eligol.Grid{}} | {:error, String.t}
  def step(grid) do
    new_cells = grid |> Grid.cells_with_coords
      |> Enum.map(fn {c, {x, y}} -> {c.alive, live_count(grid, x, y)} end)
      |> Enum.map(fn {true, count} when count in 0..1 -> false
                     {true, count} when count in 2..3 -> true
                     {true, _} -> false
                     {false, 3} -> true
                     _ -> false
                  end)
      |> Enum.map(fn alive -> %Cell{alive: alive} end)
    %{grid | cells: new_cells}
  end

  def neighbours(grid, x, y) do
    for x_ <- (x-1)..(x+1), y_ <- (y-1..y+1), not (x_ == x and y_ == y) do
      cond do
        # assumes edges are dead
        x_ in 0..(grid.width - 1) and y_ in 0..(grid.height - 1) -> Grid.at(grid, x_, y_)
        true -> %Cell{alive: false}
      end
    end
  end

  def live_neighbours(grid, x, y) do
    neighbours(grid, x, y) |> Enum.filter(&(&1.alive))
  end

  def live_count(grid, x, y) do
    live_neighbours(grid, x, y) |> length
  end
end
