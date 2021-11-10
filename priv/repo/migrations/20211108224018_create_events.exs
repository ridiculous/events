defmodule Lava.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :type, :string
      add :event_id, references(:events)
      add :source_event_id, references(:events)
      add :source_type, :string
      add :name, :string
      add :value, :text
      add :created_by, :integer
      add :updated_by, :integer

      timestamps()
    end
  end
end
