defmodule Lava.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :type, :string
    field :incident_id, :integer
    field :source_id, :integer
    field :source_type, :string
    field :updated_by, :integer
    field :created_by, :integer
    field :name, :string
    field :value, :string
    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:type, :incident_id, :source_id, :source_type, :name, :value, :created_by, :updated_by])
    |> validate_required([:type, :incident_id, :source_id, :source_type, :name, :value, :created_by, :updated_by])
  end
end
