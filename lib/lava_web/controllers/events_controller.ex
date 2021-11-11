defmodule LavaWeb.EventsController do
  use LavaWeb, :controller
  alias Lava.Events
  alias Lava.Events.Event
  alias Lava.Entities.Incident

  def index(conn, _params) do
    render(conn, "index.html", events: Events.source_events)
  end

  def new(conn, params) do
    render(conn, "new.html", changeset: Events.change_event(%Event{}))
  end

  def create(conn, params) do
    event = Events.create(parse_type(params), params["event"])
    case event do
      %Event{} -> conn
                  |> put_flash(:info, "Event #{event.id} created successfully.")
                  |> redirect(to: "/")
      {:error, %Ecto.Changeset{} = changeset} -> conn
                                                 |> put_flash(
                                                      :error,
                                                      "Poop, it failed. #{inspect(changeset.errors)}"
                                                    )
                                                 |> render("new.html", changeset: changeset)
    end
  end

  def create_incident(conn, params) do
    event = Events.create(Incident, params)
    case event do
      %Event{} -> conn
                  |> put_flash(:info, "Event #{event.id} created successfully.")
                  |> redirect(to: "/")
      {:error, %Ecto.Changeset{} = changeset} -> conn
                                                 |> put_flash(
                                                      :error,
                                                      "Poop, it failed. #{inspect(changeset.errors)}"
                                                    )
                                                 |> redirect(to: "/")
    end

  end

  def show(conn, %{"id" => id}) do
    event = Events.get_event!(id)
    render(conn, "show.html", event: event, events: [event] ++ event.source_events)
  end

  defp parse_type(%{"event" => %{"type" => type}}), do: String.to_existing_atom("Elixir.Lava.#{type}")

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
