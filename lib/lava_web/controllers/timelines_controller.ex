defmodule LavaWeb.TimelinesController do
  use LavaWeb, :controller

  alias Lava.Repo
  alias Lava.Events
  alias Lava.Events.Event
  alias Lava.Events.Timeline

  def new(conn, _params) do
    render(
      conn,
      "new.html",
      changeset: %Timeline{}
                 |> Timeline.changeset(%{})
    )
  end

  def create(conn, %{"timeline" => params}) do
    timeline = %Timeline{}
               |> Timeline.changeset(params)
               |> Repo.insert()
    case timeline do
      {:ok, tl} ->
        conn
        |> put_flash(:info, "Timeline created successfully.")
        |> redirect(to: Routes.timelines_path(conn, :show, tl))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Poop, it failed. #{inspect(changeset.errors)}")
        |> render("new.html", changeset: changeset)
    end
  end

  def show(conn, params) do
    tl = Repo.get!(Timeline, params["id"])
    render(conn, "show.html", timeline: tl, events: Events.by_timeline(tl))
  end
end
