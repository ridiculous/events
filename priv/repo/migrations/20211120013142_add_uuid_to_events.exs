defmodule Lava.Repo.Migrations.AddUUIDToEvents do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :uuid, :string
    end
    create unique_index(:events, [:uuid])
  end
end
