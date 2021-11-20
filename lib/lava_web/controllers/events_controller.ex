defmodule LavaWeb.EventsController do
  use LavaWeb, :controller
  alias Lava.Events
  alias Lava.Events.Event
  alias Lava.Entities.Incident
  alias LavaWeb.EventsView

  def index(conn, _params) do
    render(conn, "index.html", events: Events.source_events)
  end

  def new(conn, params) do
    parent_event = case params do
      %{"event_id" => ""} -> nil
      %{"event_id" => id} -> Events.get_event!(id)
      %{} -> nil
    end
    event = if parent_event do
      %Event{type: EventsView.type("#{Events.Attr}")}
    else
      %Event{}
    end
    render(conn, "new.html", changeset: Events.change_event(event), event: parent_event)
  end

  def create(conn, %{"event" => event_params}) do
    source_event = case event_params do
      %{"source_event_id" => id} -> Events.get_event!(id)
      _ -> nil
    end
    event = if source_event do
      Events.create(parse_type(event_params), event_params, source_event)
    else
      Events.create(parse_type(event_params), event_params)
    end
    case event do
      %Event{} -> conn
                  |> put_flash(:info, "Event #{event.id} created successfully.")
                  |> redirect(to: "/events/#{event_params["source_event_id"]}")
      {:error, %Ecto.Changeset{} = changeset} -> conn
                                                 |> put_flash(
                                                      :error,
                                                      "Poop, it failed. #{inspect(changeset.errors)}"
                                                    )
                                                 |> render("new.html", changeset: changeset, event: source_event)
    end
  end

  def show(conn, %{"id" => id}) do
    event = Events.get_event!(id)
            |> Lava.Repo.preload(:source_events)
    render(conn, "show.html", event: event, events: event.source_events)
  end

  defp parse_type(%{"type" => type}) do
    if type == "" do
      ""
    else
      String.to_existing_atom("Elixir.Lava.#{type}")
    end
  end
end
