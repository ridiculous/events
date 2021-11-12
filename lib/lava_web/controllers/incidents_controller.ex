defmodule LavaWeb.IncidentsController do
  use LavaWeb, :controller
  alias Lava.Incidents
  plug :set_page_title
  defp set_page_title(conn, _), do: assign(conn, :page_title, "Recent Incidents")

  def index(conn, _params) do
    render(conn, "index.html", events: Incidents.list_incidents)
  end
end
