defmodule LavaWeb.EventsView do
  use LavaWeb, :view
  alias Lava.Events

  @types [
    Lava.Entities.Incident,
    Lava.Entities.Person,
    Lava.Activities.AddAllegedVictim,
    Lava.Activities.OutgoingCall,
    Lava.Events.Attr
  ]

  def type(t) do
    String.split(t, ".")
    |> Enum.take(-2)
    |> Enum.join(".")
  end

  def types do
    Enum.map(@types, fn t -> type("#{t}") end)
  end

  def top_level_events do
    Events.source_events |> Enum.map(fn event -> {"#{type(event.type)} #{event.id}", event.id} end)
  end
end
