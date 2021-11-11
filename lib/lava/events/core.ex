defmodule Lava.Events.Core do
  @moduledoc """
  Everything is an event, which is primarily a key and a value store
  All keys and values are strings
  Events can have many other events related to it, or nested under it
  Events are Structs, which can implement the hook protocol to modify behavior after create/update/delete
  The idea is this simple system design can be applied to run much of an evented system, and also be used to source the state of the system (aka event-sourced design).

  ## Usage
  Utilize this module in your system by defining your own structs to represent activities and entities in your system, and pass them
  to the create_event function, with data in the format of either a simple key/value pair or a custom map, which will be broken down into key/value pairs
  and saved as nested events.
  """
  defmacro __using__(_) do
    quote do
      import Ecto.Query, warn: false
      alias Lava.Repo
      alias Lava.Events.Event
      alias Lava.Events.Attr
      # Take the given params and create an event with them.
      # Using the remaining params, check if any are defined on the given Type, and use those to create subsequent events
      @spec create(module, map) :: Event
      def create(type, attrs = %{}) do
        create_event(type, attrs)
        |> create_attrs(params_for_type(type, attrs))
      end

      def create(type, attrs = %{}, source = %Event{}) do
        create_event(type, attrs, source)
        |> create_attrs(params_for_type(type, attrs))
      end

      def create(type, attrs = %{}, source = %Event{}, event = %Event{}) do
        create_event(type, attrs, source, event)
        |> create_attrs(params_for_type(type, attrs))
      end

      # Protected.

      defp params_for_type(type, params) do
        keys = Map.keys(struct(type))
               |> List.delete(:__struct__)
               |> Enum.map(fn key -> Atom.to_string(key) end)
        Map.take(params, keys)
      end

      defp create_event(type, attrs = %{}) do
        build_event(type, attrs)
        |> Repo.insert()
      end

      # Create and link
      defp create_event(type, attrs = %{}, source_event = %Event{}) do
        build_event(type, attrs)
        |> Ecto.Changeset.put_assoc(:source_event, source_event)
        |> Repo.insert()
      end

      # Create and double-link
      defp create_event(type, attrs = %{}, source_event = %Event{}, event = %Event{}) do
        build_event(type, attrs)
        |> Ecto.Changeset.put_assoc(:source_event, source_event)
        |> Ecto.Changeset.put_assoc(:event, event)
        |> Repo.insert()
      end

      defp build_event(type, attrs) do
        %Event{type: "#{type}"}
        |> Event.changeset(attrs)
      end

      defp create_attrs({:error, changeset}, _), do: {:error, changeset}
      defp create_attrs({:ok, parent}, attrs) do
        for {name, value} <- attrs do
          {:ok, _} = create_event(
            Attr,
            %{name: "#{name}", value: "#{value}", updated_by: parent.updated_by, created_by: parent.created_by},
            parent
          )
        end
        parent
      end
    end
  end
end
