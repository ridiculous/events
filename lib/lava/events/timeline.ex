defmodule Lava.Events.Timeline do
  use Ecto.Schema
  import Ecto.Changeset

  schema "timelines" do
    field :name, :string
    field :created_by, :string

    timestamps()
  end

  @doc false
  def changeset(timeline, attrs) do
    timeline
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
