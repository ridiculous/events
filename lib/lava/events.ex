defmodule Lava.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  alias Lava.Repo

  alias Lava.Events.Event
  alias Lava.Events.Attr
  alias Lava.Events.Hooks

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events do
    Repo.all(Event)
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id), do: Repo.get!(Event, id) |> Repo.preload(:events)

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs = %{}) do
    build_event(attrs)
    |> Repo.insert()
  end

  # Create and link
  def create_event(attrs = %{}, source_event = %Event{}) do
    build_event(attrs)
    |> Ecto.Changeset.put_assoc(:source_event, source_event)
    |> Repo.insert()
  end

  # Create and double-link
  def create_event(attrs = %{}, source_event = %Event{}, event = %Event{}) do
    build_event(attrs)
    |> Ecto.Changeset.put_assoc(:source_event, source_event)
    |> Ecto.Changeset.put_assoc(:event, event)
    |> Repo.insert()
  end

  defp build_event(attrs) do
    %Event{type: "#{attrs.__struct__}"}
    |> Event.changeset(Map.from_struct(attrs))
  end

  def create(attrs = %{}) do
    create_event(attrs)
    |> create_extras(attrs)
    |> run_hooks(attrs)
  end

  def create(attrs = %{}, source = %Event{}) do
    create_event(attrs, source)
    |> create_extras(attrs)
    |> run_hooks(attrs)
  end

  def create(attrs = %{}, source = %Event{}, event = %Event{}) do
    create_event(attrs, source, event)
    |> create_extras(attrs)
    |> run_hooks(attrs)
  end

  defp create_extras({:ok, parent}, attrs) do
    extras = Map.from_struct(attrs)
             |> Map.drop([:name, :value])
    for {name, value} <- extras do
      {:ok, _} = create_event(%Attr{name: "#{name}", value: "#{value}"}, parent)
    end
    parent
  end

  defp create_extras({:error, message}, _) do
    raise "Failed to create event #{message}"
  end

  def run_hooks(event, attrs) do
    Hooks.event_created(attrs)
    event
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{data: %Event{}}

  """
  def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end
end
