defmodule Lava.Events do
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

  ## Protocol
  Hook into the creation of events by defining the Lava.Events.Hooks protocol for the target structs
  """

  import Ecto.Query, warn: false
  alias Lava.Repo

  alias Lava.Events.Event
  alias Lava.Events.Attr
  alias Lava.Events.Hooks

  def get_event!(id),
      do: Repo.get!(Event, id)
          |> Repo.preload(:source_events)

  def create(attrs = %{}) do
    create_event(attrs)
    |> create_extras(attrs)
  end

  def create(attrs = %{}, source = %Event{}) do
    create_event(attrs, source)
    |> create_extras(attrs)
  end

  def create(attrs = %{}, source = %Event{}, event = %Event{}) do
    create_event(attrs, source, event)
    |> create_extras(attrs)
  end

  # Protected.

  defp create_event(attrs = %{}) do
    build_event(attrs)
    |> Repo.insert()
    |> run_hooks(attrs)
  end

  # Create and link
  defp create_event(attrs = %{}, source_event = %Event{}) do
    build_event(attrs)
    |> Ecto.Changeset.put_assoc(:source_event, source_event)
    |> Repo.insert()
    |> run_hooks(attrs)
  end

  # Create and link a nested attr event
  defp create_event({key, val}, source = %Event{}) do
    create_event(%Attr{name: "#{key}", value: "#{val}"}, source)
  end

  # Create and double-link
  defp create_event(attrs = %{}, source_event = %Event{}, event = %Event{}) do
    build_event(attrs)
    |> Ecto.Changeset.put_assoc(:source_event, source_event)
    |> Ecto.Changeset.put_assoc(:event, event)
    |> Repo.insert()
    |> run_hooks(attrs)
  end

  defp build_event(attrs) do
    %Event{type: "#{infer_type(attrs)}"}
    |> Event.changeset(get_attrs(attrs))
  end

  defp infer_type(%{:__struct__ => type}), do: type
  defp infer_type(%{:type => type}), do: type
  defp infer_type(%{"type" => type}), do: type
  defp infer_type(%{}), do: raise("Type of event couldn't be determined. Use a named Struct or pass :type")

  defp create_extras({:error, changeset}, _), do: {:error, changeset}
  defp create_extras({:ok, parent}, attrs) do
    # Drop these attrs cause they should've already been saved to the parent, so maybe can skip creating extras
    extras = get_attrs(attrs)
             |> Map.drop(Map.keys(parent))
    for {name, value} <- extras do
      {:ok, _} = create_event({name, value}, parent)
    end
    parent
  end

  defp get_attrs(attrs) when is_struct(attrs) do
    Map.from_struct(attrs)
  end

  defp get_attrs(attrs) when is_map(attrs) do
    for {key, val} <- attrs, into: %{}, do: {get_attr_key(key), val}
  end

  defp get_attr_key(key) when is_atom(key), do: key
  defp get_attr_key(key) when is_binary(key) do
    String.to_atom(key)
  end

  defp run_hooks({:ok, event}, attrs) do
    Hooks.event_created(attrs, event)
  end

  defp run_hooks(result, _), do: result
end
