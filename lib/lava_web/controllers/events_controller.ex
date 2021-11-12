defmodule LavaWeb.EventsController do
  use LavaWeb, :controller
  alias Lava.Events
  alias Lava.Events.Event
  alias Lava.Entities.Incident

  def index(conn, _params) do
    render(conn, "index.html", events: Events.source_events)
  end

  def new(conn, params) do
    event = case params do
      %{"event_id" => ""} -> nil
      %{"event_id" => id} -> Events.get_event!(id)
      %{} -> nil
    end
    render(conn, "new.html", changeset: Events.change_event(%Event{}), event: event)
  end

  def create(conn, params) do
    event = case params["event"] do
      %{"source_event_id" => id} -> Events.create(parse_type(params), params["event"], Events.get_event!(id))
      _ -> Events.create(parse_type(params), params["event"])
    end
    case event do
      %Event{} -> conn
                  |> put_flash(:info, "Event #{event.id} created successfully.")
                  |> redirect(to: "/events/#{params["event"]["source_event_id"]}")
      {:error, %Ecto.Changeset{} = changeset} -> conn
                                                 |> put_flash(
                                                      :error,
                                                      "Poop, it failed. #{inspect(changeset.errors)}"
                                                    )
                                                 |> render("new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    event = Events.get_event!(id)
            |> Lava.Repo.preload(:source_events)
    render(conn, "show.html", event: event, events: event.source_events)
  end

  defp parse_type(
         %{
           "event" => %{
             "type" => type
           }
         }
       ), do: String.to_existing_atom("Elixir.Lava.#{type}")
end
