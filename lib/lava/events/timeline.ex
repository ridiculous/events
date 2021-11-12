defmodule Lava.Events.Timeline do
  use Ecto.Schema
  import Ecto.Changeset

  schema "timelines" do
    field :created_by, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(timeline, attrs) do
    timeline
    |> cast(attrs, [:created_by, :name])
  end
end
