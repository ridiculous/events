defmodule Lava.ShoppingCart.Cart do
  use Ecto.Schema
  import Ecto.Changeset

  schema "carts" do
    field :user_uuid, Ecto.UUID
    timestamps()
    has_many :items, Lava.ShoppingCart.CartItem
  end

  @doc false
  def changeset(cart, attrs) do
    cart
    |> cast(attrs, [:user_uuid])
    |> validate_required([:user_uuid])
    |> unique_constraint(:user_uuid)
  end
end
