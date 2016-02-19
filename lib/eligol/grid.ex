defmodule Eligol.Grid do
  alias Eligol.Grid
  alias Eligol.Cell

  defstruct [width: 0, height: 0, cells: []]

  @spec new!(pos_integer, pos_integer) :: %Grid{}
  def new!(width, height)
  when is_integer(width) and is_integer(height) do
    cells = for _ <- 0..(width * height), do: %Cell{}
    %Grid{width: width, height: height, cells: cells}
  end

  def new!(list_of_states) when is_list(list_of_states) do
    height = length(list_of_states)
    width = length(hd list_of_states)
    cells = for row <- list_of_states, c <- row, do: %Cell{alive: c == 1}
    %Grid{width: width, height: height, cells: cells}
  end

  @spec size(%Grid{}) :: pos_integer
  def size(grid) do
    grid.width * grid.height
  end

  @spec at(%Grid{}, pos_integer, pos_integer) :: %Cell{}
  def at(grid, x, y) do
    index = grid |> coords_to_index(x, y)
    grid.cells |> Enum.fetch!(index)
  end

  @spec set(%Grid{}, pos_integer, pos_integer, Cell.cell_state) :: %Grid{}
  def set(grid, x, y, liveness) do
    index = grid |> coords_to_index(x, y)
    cell = Enum.at(grid.cells, index)
    %{grid | cells: grid.cells |> List.replace_at(index, %{cell | alive: liveness})}
  end

  @spec index_to_coords(%Grid{}, pos_integer) :: {pos_integer, pos_integer}
  def index_to_coords(grid, index) do
    {rem(index, grid.width), div(index, grid.width)}
  end

  @spec coords_to_index(%Grid{}, pos_integer, pos_integer) :: pos_integer
  def coords_to_index(grid, x, y) do
    y * grid.width + x
  end

  def cells_with_coords(grid) do
    grid.cells
      |> Enum.with_index
      |> Enum.map(fn {cell, index} -> {cell, index_to_coords(grid, index)} end)
  end

  def to_string(grid) do
    for row <- grid.cells |> Stream.chunk(grid.width) do
      row |> Enum.map(&inspect/1) |> Enum.join("")
    end |> Enum.join("\n")
  end
end

defimpl Inspect, for: Eligol.Grid do
  def inspect(grid, _) do
    Eligol.Grid.to_string(grid)
  end
end
