defmodule Lava.Repo.Migrations.CreateTimelines do
  use Ecto.Migration

  def change do
    create table(:timelines) do
      add :created_by, :string
      add :name, :string

      timestamps()
    end
  end
end
