defmodule Lava.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :type, :string
      add :event_id, references(:events, on_delete: :nilify_all)
      add :source_event_id, references(:events, on_delete: :nilify_all)
      add :source_type, :string
      add :name, :string
      add :value, :text
      add :created_by, :integer
      add :updated_by, :integer

      timestamps()
    end

    create unique_index(:events, [:source_event_id, :name])
    create index(:events, [:event_id, :name])
  end
end
