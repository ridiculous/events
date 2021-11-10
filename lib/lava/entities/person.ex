defmodule Lava.Entities.Person do
  defstruct name: "Name", value: "Ryan"

  defimpl Lava.Events.Hooks, for: __MODULE__ do
    def event_created(attrs), do: IO.puts("** New Person was added \"#{attrs.value}\"")
  end
end
