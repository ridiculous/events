defmodule LavaWeb.TimelinesController do
  use LavaWeb, :controller

  alias Lava.Repo
  alias Lava.Events
  alias Lava.Events.Event
  alias Lava.Events.Timeline

  def show(conn, params) do
    tl = Repo.get!(Timeline, params["id"])
    render(conn, "show.html", timeline: tl, events: Events.by_timeline(tl))
  end
end
