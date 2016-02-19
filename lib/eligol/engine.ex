defmodule Eligol.Engine do
  alias Eligol.{Cell,Grid}
  # things i need
  # - a grid / world
  # - a cell
  #   - alive | dead
  # - what do on edge (live, dead, wrap)
  @spec step(%Eligol.Grid{}, list) :: {:ok, %Eligol.Grid{}} | {:error, String.t}
  def step(grid, opts \\ []) do
    new_cells = grid |> Grid.cells_with_coords
      |> Enum.map(fn {c, {x, y}} -> {c.alive, live_count(grid, x, y, opts)} end)
      |> Enum.map(fn {true, count} when count in 0..1 -> false
                     {true, count} when count in 2..3 -> true
                     {true, _} -> false
                     {false, 3} -> true
                     _ -> false
                  end)
      |> Enum.map(fn alive -> %Cell{alive: alive} end)
    %{grid | cells: new_cells}
  end

  def neighbours(grid, x, y, opts \\ []) do
    edges = opts |> Keyword.get(:edges, :dead)
    for x_ <- (x-1)..(x+1), y_ <- (y-1..y+1), not (x_ == x and y_ == y) do
      if edges == :wrap do
        x_ = cond do
          x_ < 0 -> grid.width + x_
          true -> rem(x_, grid.width)
        end
        y_ = cond do
          y_ < 0 -> grid.height + y_
          true -> rem(y_, grid.height)
        end
      end
      cond do
        x_ in 0..(grid.width - 1) and y_ in 0..(grid.height - 1) -> Grid.at(grid, x_, y_)
        true -> %Cell{alive: edges == :alive}
      end
    end
  end

  def live_neighbours(grid, x, y, opts \\ []) do
    neighbours(grid, x, y, opts) |> Enum.filter(&(&1.alive))
  end

  def live_count(grid, x, y, opts \\ []) do
    live_neighbours(grid, x, y, opts) |> length
  end

  def print_and_step(grid, steps \\ -1, opts \\ []) do
    IO.puts(Grid.to_string(grid) <> "\n")
    grid = step(grid, opts)
    # :timer.sleep(500)
    if steps != 0, do: print_and_step(grid, steps - 1, opts)
  end
end
