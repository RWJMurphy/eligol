defmodule Eligol.Cell do
  @type cell_state :: boolean
  defstruct [alive: false]
end

defimpl Inspect, for: Eligol.Cell do
  def inspect(cell, _), do: if cell.alive, do: "#", else: " "
end
