defmodule Lava.Repo.Migrations.AddEventsToTimeline do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :timeline_id, references(:timelines)
    end
  end
end
