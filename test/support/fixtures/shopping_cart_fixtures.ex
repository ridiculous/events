defmodule Lava.ShoppingCartFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lava.ShoppingCart` context.
  """

  @doc """
  Generate a unique cart user_uuid.
  """
  def unique_cart_user_uuid do
    raise "implement the logic to generate a unique cart user_uuid"
  end

  @doc """
  Generate a cart.
  """
  def cart_fixture(attrs \\ %{}) do
    {:ok, cart} =
      attrs
      |> Enum.into(%{
        user_uuid: unique_cart_user_uuid()
      })
      |> Lava.ShoppingCart.create_cart()

    cart
  end

  @doc """
  Generate a cart_items.
  """
  def cart_items_fixture(attrs \\ %{}) do
    {:ok, cart_items} =
      attrs
      |> Enum.into(%{
        price_when_carted: "120.5",
        quantity: 42
      })
      |> Lava.ShoppingCart.create_cart_items()

    cart_items
  end
end
