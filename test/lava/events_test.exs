defmodule Lava.EventsTest do
  use Lava.DataCase

  alias Lava.Events

  describe "events" do
    alias Lava.Events.Event

    import Lava.EventsFixtures

    @invalid_attrs %{created_by: nil, incident_id: nil, name: nil, source_id: nil, source_type: nil, type: nil, updated_by: nil, value: nil}

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Events.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Events.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{created_by: 42, incident_id: 42, name: "some name", source_id: 42, source_type: "some source_type", type: "some type", updated_by: 42, value: "some value"}

      assert {:ok, %Event{} = event} = Events.create_event(valid_attrs)
      assert event.created_by == 42
      assert event.incident_id == 42
      assert event.name == "some name"
      assert event.source_id == 42
      assert event.source_type == "some source_type"
      assert event.type == "some type"
      assert event.updated_by == 42
      assert event.value == "some value"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      update_attrs = %{created_by: 43, incident_id: 43, name: "some updated name", source_id: 43, source_type: "some updated source_type", type: "some updated type", updated_by: 43, value: "some updated value"}

      assert {:ok, %Event{} = event} = Events.update_event(event, update_attrs)
      assert event.created_by == 43
      assert event.incident_id == 43
      assert event.name == "some updated name"
      assert event.source_id == 43
      assert event.source_type == "some updated source_type"
      assert event.type == "some updated type"
      assert event.updated_by == 43
      assert event.value == "some updated value"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_event(event, @invalid_attrs)
      assert event == Events.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Events.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Events.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Events.change_event(event)
    end
  end
end
