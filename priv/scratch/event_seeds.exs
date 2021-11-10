# Create and link events representing an incident

alias Lava.Events

incident = Events.create(%Lava.Entities.Incident{})
person = Events.create(%Lava.Entities.Person{value: "Ryan"})
role = Events.create(
  %Lava.Activities.AddAllegedVictim{name: "name", value: person.value},
  incident,
  person
)
outgoing = Events.create(
  %Lava.Activities.OutgoingCall{to: "+14152604528", notes: "Notes go here", date: DateTime.utc_now()},
  incident
)

#outgoing2 = Events.create(
#  %Lava.Activities.OutgoingCall{to: "+19256407065", notes: "Called by baby boo", date: DateTime.utc_now()},
#  incident
#)


#= Summary
# This was a fun exercise because we get to see test the boundaries of what's possible with just an events data store.
# Whats more tho, is how different a system can be, if it's thought of in a fundamentally different way than we are used
# for typical relational database backed web applications.










# Old thought process in developing the evented system:

# How to have multiple schemas...? Store schema and data as a hash maybe, let the module load it. We'd lose ability to track changes to a specific node. I'm not so sure about schema need

## If it's key value, would it make sense to hook in at the changeset level, and create or update event_nodes based on that
# DO we need an internal_type to reference module directly if using namespace?? Would type be enough? How would we do that?

# What if everything was an event? And instead of building tables to store entities, we focus on actions.
# What if we could also map certain events to entities
# Parent event table that possibly has a mapping to attributes, or configuration, for that event?
#   Maybe then rename events to event_nodes or something? Essentially a dedicated table for nested events/details like a form

# Event type can be container or attribute or something?
# Should EventAttrs be a specific type?? Maybe that would be easier

# The idea is to have a struct store the main event or entity, which can be broken down in multiple smaller events.
# A protocol

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
