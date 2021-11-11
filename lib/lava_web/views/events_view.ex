defmodule LavaWeb.EventsView do
  use LavaWeb, :view

  def type(t) do
    String.split(t, ".") |> Enum.drop(2) |> Enum.join(".")
  end
end
