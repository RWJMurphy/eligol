defmodule Eligol.Grid do
  alias Eligol.Grid
  alias Eligol.Cell

  defstruct [width: 0, height: 0, cells: []]
  @spec new!(pos_integer, pos_integer) :: %Grid{
    width: pos_integer, height: pos_integer, cells: list(%Cell{})}
  def new!(width \\ 128, height \\ 128) do
    cells = for _ <- 0..(width * height), do: %Cell{}
    %Grid{width: width, height: height, cells: cells}
  end

  @spec size(%Grid{}) :: pos_integer
  def size(grid) do
    grid.width * grid.height
  end

  @spec at(%Grid{}, pos_integer, pos_integer) :: %Cell{}
  def at(grid, x, y) do
    index = grid |> coords_to_index(x, y)
    grid.cells |> Enum.at(index)
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
end
