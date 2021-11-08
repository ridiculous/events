defmodule Lava.EventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lava.Events` context.
  """

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        created_by: 42,
        incident_id: 42,
        name: "some name",
        source_id: 42,
        source_type: "some source_type",
        type: "some type",
        updated_by: 42,
        value: "some value"
      })
      |> Lava.Events.create_event()

    event
  end
end
