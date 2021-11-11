defmodule Lava.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :type, :string
    field :source_type, :string
    field :updated_by, :integer
    field :created_by, :integer
    field :name, :string
    field :value, :string
    timestamps()

    belongs_to :event, Lava.Events.Event
    belongs_to :source_event, Lava.Events.Event
    has_many :events, Lava.Events.Event
    has_many :source_events, Lava.Events.Event, foreign_key: :source_event_id
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :value, :created_by, :updated_by])
  end
end
