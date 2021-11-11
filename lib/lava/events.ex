defmodule Lava.Events do
  use Lava.Events.Core

  def get_event!(id),
      do: Repo.get!(Event, id)
          |> Repo.preload(:source_events)

  def source_events do
    Repo.all(from c in Event, where: is_nil(c.source_event_id), order_by: c.id)
  end

  def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end

  def get_parents(event = %Event{}, list) do
    parent = Repo.preload(event, :source_event)
    get_parents(parent.source_event, [parent] ++ list)
  end
  def get_parents(nil, list), do: list
end
