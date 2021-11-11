defmodule Lava.Entities do
  import Ecto.Query, warn: false
  alias Lava.Repo
  alias Lava.Events.Event
  alias Lava.Entities.Incident

  def get_incidents do
    Repo.all(from c in Event, where: c.type == ^"#{Incident}")
  end
end
