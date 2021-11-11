defmodule LavaWeb.EventsView do
  use LavaWeb, :view

  @types [Lava.Entities.Incident, Lava.Entities.Person, Lava.Activities.AddAllegedVictim, Lava.Activities.OutgoingCall]

  def type(t) do
    String.split(t, ".") |> Enum.drop(2) |> Enum.join(".")
  end

  def types do
    Enum.map(@types, fn t -> type("#{t}") end)
  end
end
