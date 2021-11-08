defmodule Lava.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :type, :string
      add :incident_id, :integer
      add :source_id, :integer
      add :source_type, :string
      add :name, :string
      add :value, :string
      add :created_by, :integer
      add :updated_by, :integer

      timestamps()
    end
  end
end
