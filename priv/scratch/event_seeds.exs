#= DESCRIPTION
# Let's describe the current system
# Everything is an event, which is a record that stores primarily a key and a value
# All keys and values are strings
# Events can have many other events related to it
# Event type is the action driving the event

# The idea is this simple system design can be applied to create all the data structures we need, and also be used to source the state of the system
# Which means recreate the system from scratch by replaying the event log (aka event-sourced design).

# Event links??

# Create an event with an outgoing call attributes and have it stored as an event
defmodule Lava.Events.OutgoingCall do
  #  @derive [Evented]
  defstruct [:to, :date, :notes]
end

defmodule Lava.Events.Attrs do
  defstruct [:name, :value]
end

defmodule Lava.Events.Person do
  defstruct name: "Name", value: "Ryan"
end

defmodule Lava.Events.Role do
  defstruct [:name, :value]
end

defmodule Lava.Events.AllegedVictim do
  defstruct []
end

defmodule Lava.Events.Incident do
  defstruct name: "state", value: "wip"
end

defmodule Example do
  def create(attrs = %{}) do
    Lava.Events.create_event(attrs) |> create_extras(attrs)
  end

  def create(attrs = %{}, source = %Lava.Events.Event{}) do
    Lava.Events.create_event(attrs, source) |> create_extras(attrs)
  end

  def create(attrs = %{}, source = %Lava.Events.Event{}, event = %Lava.Events.Event{}) do
    Lava.Events.create_event(attrs, source, event) |> create_extras(attrs)
  end

  defp create_extras({:ok, parent}, attrs) do
    extras = Map.from_struct(attrs) |> Map.drop([:name, :value])
    for {name, value} <- extras do
      Lava.Events.create_event(%Lava.Events.Attrs{name: "#{name}", value: "#{value}"}, parent)
    end
    parent
  end
end

incident = Example.create(%Lava.Events.Incident{})
person = Example.create(%Lava.Events.Person{value: "Ryan"})
role = Example.create(%Lava.Events.Role{name: "role", value: "alleged_victim"}, incident, person)
#Lava.Events.link_event(%{from: person, to: role, name: "role"})
#Lava.Events.link_event(%{from: role, to: incident, name: "role"})
outgoing = Example.create(%Lava.Events.OutgoingCall{to: "+14152604528", notes: "Notes go here", date: DateTime.utc_now()}, incident)

# How to have multiple schemas...? Store schema and data as a hash maybe, let the module load it. We'd lose ability to track changes to a specific node. I'm not so sure about schema need

## If it's key value, would it make sense to hook in at the changeset level, and create or update event_nodes based on that
# DO we need an internal_type to reference module directly if using namespace?? Would type be enough? How would we do that?

# What if everything was an event? And instead of building tables to store entities, we focus on actions.
# What if we could also map certain events to entities
# Parent event table that possibly has a mapping to attributes, or configuration, for that event?
#   Maybe then rename events to event_nodes or something? Essentially a dedicated table for nested events/details like a form

defprotocol Evented do
  def create_event(type, data)
end

defimpl Evented, for: Any do
  defdelegate create_event(type, data), to: Lava.Events

  def create_event(event, key, value) when is_integer(value) do
    Lava.Events.create_event(Integer, event, %{key => value})
  end

  def create_event(event, key, value) when is_float(value) do
    Lava.Events.create_event(Float, event, %{key => value})
  end
  def create_event(event, key, value) when is_boolean(value) do

  end
  def create_event(event, key, value) when is_atom(value) do

  end
  def create_event(event, key, value) when is_binary(value) do
    Lava.Events.create_event(String, event, %{key => value})
  end
  def create_event(event, key, value) when is_nil(value) do

  end
  def create_event(event, key, value) when is_struct(value) do
    #    if Map.has_key?(b, :__struct__)

  end
end

# Event type can be container or attribute or something?
# Should EventAttrs be a specific type?? Maybe that would be easier


Evented.create_event(%OutgoingCall{to: "123", notes: "abce"})

defmodule A do
  def go(a = %{}) do
    a.__struct__
  end
end

# The idea is to have a struct store the main event or entity, which can be broken down in multiple smaller events.
# A protocol

defmodule Person do
  defstruct [:name, :age]
end

Evented.create_event(person)

event = Example.create_event(
  1,
  "OutgoingCall",
  %{to: "+9256407065", date: DateTime.utc_now(), notes: "Talked with @DrHibbert about the AV and such"}
)
a = Lava.Events.get_event!(event.id)
    |> Lava.Repo.preload(:events)

# Scenario

# What happens when we add a new person and add them to a certain incident. If everything is an event... We need a global
# PersonEvent, an AddAV event.
# Add person could include what data exactly? Show a summary maybe. Key value would be... name: Name
# The event_id could point to the original PersonEvent? Use that to tie them together... interesting
# Cause the AddAV event could use incident_id and event_id to form a join between the current case and person, with event type representing role.

# Would the incident be an event too? I mean, we just need a top level record to refer to... hmm.


# What if

# Are limiting ourselves to the key/value setup? I guess querying them isn't that realistic, so perhaps we should just go all in on storing json, or some sort of serialized data
# We would need to store the current schema as well, used to encode/decode the data.

# The problem still persists of creating true bidirectional relationships among events. They kind of just flow one way. When would we need this?