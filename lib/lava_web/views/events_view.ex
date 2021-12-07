defmodule LavaWeb.EventsView do
  use LavaWeb, :view
  alias Lava.Events

  @types [
    Lava.Entities.Person,
    Lava.Entities.Address,
    Lava.Entities.Phone,
    Lava.Entities.HomeConcern,
    Lava.Entities.HealthConcern,
    Lava.Entities.AbuseIndicator,
    Lava.Activities.StartIncidentReport,
    Lava.Activities.AddReporter,
    Lava.Activities.AddAllegedVictim,
    Lava.Activities.AddAllegedPerpetrator,
    Lava.Activities.AddCollateralContact,
    Lava.Activities.AddComplainant,
    Lava.Activities.OutgoingCall,
    Lava.Activities.IncomingCall,
    Lava.Activities.AddAllegedAbuse,
    Lava.Activities.AddAddress,
    Lava.Activities.AddNote,
    Lava.Activities.AddHomeConcern,
    Lava.Activities.AddHealthConcern,
    Lava.Activities.AddDisposition,
    Lava.Activities.Pin,
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
