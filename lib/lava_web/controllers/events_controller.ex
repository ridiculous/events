defmodule LavaWeb.EventsController do
  use LavaWeb, :controller
  alias Lava.Events
  alias Lava.Events.Event

  def index(conn, _params) do
    render(conn, "index.html", events: Lava.Entities.get_incidents)
  end

  def create_incident(conn, params) do
    event = Events.create(%Lava.Entities.Incident{})
    case event do
      %Event{} -> conn
                  |> put_flash(:info, "Event #{event.id} created successfully.")
                  |> redirect(to: "/")
      {:error, %Ecto.Changeset{} = changeset} -> conn
                                                 |> put_flash(:error, "Poopsies, it failed. #{inspect(changeset.errors)}")
                                                 |> redirect(to: "/")
    end

  end

  def show(conn, %{"id" => id}) do
    event = Events.get_event!(id)
    render(conn, "show.html", events: [event] ++ event.source_events)
  end

  #  def index(conn) do
  #
  #  end
  #
  #  def show(conn, %{"id" => id}) do
  #
  #  end
  #
  #  def create(conn, params) do
  #
  #  end
end