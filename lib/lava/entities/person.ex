defmodule Lava.Entities.Person do
  defstruct name: "Name", value: "Ryan"

  defimpl Lava.Events.Hooks, for: __MODULE__ do
    def event_created(attrs, event), do: IO.puts("** New Person was added \"#{attrs.value}\" with Event ID #{event.id}")
  end
end
