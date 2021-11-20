defmodule LavaWeb.EventsView do
  use LavaWeb, :view
  alias Lava.Events

  @types [
    Lava.Entities.Person,
    Lava.Entities.Address,
    Lava.Entities.Phone,
    Lava.Entities.HomeConcern,
    Lava.Activities.StartIncidentReport,
    Lava.Activities.AddAllegedVictim,
    Lava.Activities.AddAllegedPerpetrator,
    Lava.Activities.AddCollateralContact,
    Lava.Activities.AddComplainant,
    Lava.Activities.OutgoingCall,
    Lava.Activities.IncomingCall,
    Lava.Activities.AddAbuseIndicators,
    Lava.Activities.AddAddress,
    Lava.Activities.AddNote,
    Lava.Activities.AddHomeConcern,
    Lava.Activities.AddDisposition,
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
