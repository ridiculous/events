defmodule Lava.Incidents do
  import Ecto.Query, warn: false
  alias Lava.Repo
  alias Lava.Events.Event

  def list_incidents do
    Repo.all(from c in Event, where: c.type == ^"#{Lava.Entities.Incident}", order_by: c.id)
  end
end
