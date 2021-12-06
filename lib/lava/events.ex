defmodule Lava.Events do
  use Lava.Events.Core

  def by_timeline(timeline) do
    Repo.all(from e in Event, where: e.timeline_id == ^timeline.id and is_nil(e.source_event_id), order_by: e.inserted_at)
  end

  def get_event!(id), do: Repo.get!(Event, id)

  def source_events do
    Repo.all(from e in Event, where: is_nil(e.source_event_id) and is_nil(e.timeline_id), order_by: e.id)
  end

  def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end

  def get_parents(event = %Event{}), do: get_parents(event, [])
  def get_parents(event = %Event{}, list) do
    parent = Repo.preload(event, :source_event)
    get_parents(parent.source_event, [parent] ++ list)
  end
  def get_parents(nil, list), do: list
end
