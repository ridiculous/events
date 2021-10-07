defmodule Lava.ShoppingCartTest do
  use Lava.DataCase

  alias Lava.ShoppingCart

  describe "carts" do
    alias Lava.ShoppingCart.Cart

    import Lava.ShoppingCartFixtures

    @invalid_attrs %{user_uuid: nil}

    test "list_carts/0 returns all carts" do
      cart = cart_fixture()
      assert ShoppingCart.list_carts() == [cart]
    end

    test "get_cart!/1 returns the cart with given id" do
      cart = cart_fixture()
      assert ShoppingCart.get_cart!(cart.id) == cart
    end

    test "create_cart/1 with valid data creates a cart" do
      valid_attrs = %{user_uuid: "7488a646-e31f-11e4-aace-600308960662"}

      assert {:ok, %Cart{} = cart} = ShoppingCart.create_cart(valid_attrs)
      assert cart.user_uuid == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_cart/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ShoppingCart.create_cart(@invalid_attrs)
    end

    test "update_cart/2 with valid data updates the cart" do
      cart = cart_fixture()
      update_attrs = %{user_uuid: "7488a646-e31f-11e4-aace-600308960668"}

      assert {:ok, %Cart{} = cart} = ShoppingCart.update_cart(cart, update_attrs)
      assert cart.user_uuid == "7488a646-e31f-11e4-aace-600308960668"
    end

    test "update_cart/2 with invalid data returns error changeset" do
      cart = cart_fixture()
      assert {:error, %Ecto.Changeset{}} = ShoppingCart.update_cart(cart, @invalid_attrs)
      assert cart == ShoppingCart.get_cart!(cart.id)
    end

    test "delete_cart/1 deletes the cart" do
      cart = cart_fixture()
      assert {:ok, %Cart{}} = ShoppingCart.delete_cart(cart)
      assert_raise Ecto.NoResultsError, fn -> ShoppingCart.get_cart!(cart.id) end
    end

    test "change_cart/1 returns a cart changeset" do
      cart = cart_fixture()
      assert %Ecto.Changeset{} = ShoppingCart.change_cart(cart)
    end
  end

  describe "cart_items" do
    alias Lava.ShoppingCart.CartItem

    import Lava.ShoppingCartFixtures

    @invalid_attrs %{price_when_carted: nil, quantity: nil}

    test "list_cart_items/0 returns all cart_items" do
      cart_items = cart_items_fixture()
      assert ShoppingCart.list_cart_items() == [cart_items]
    end

    test "get_cart_items!/1 returns the cart_items with given id" do
      cart_items = cart_items_fixture()
      assert ShoppingCart.get_cart_items!(cart_items.id) == cart_items
    end

    test "create_cart_items/1 with valid data creates a cart_items" do
      valid_attrs = %{price_when_carted: "120.5", quantity: 42}

      assert {:ok, %CartItem{} = cart_items} = ShoppingCart.create_cart_items(valid_attrs)
      assert cart_items.price_when_carted == Decimal.new("120.5")
      assert cart_items.quantity == 42
    end

    test "create_cart_items/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ShoppingCart.create_cart_items(@invalid_attrs)
    end

    test "update_cart_items/2 with valid data updates the cart_items" do
      cart_items = cart_items_fixture()
      update_attrs = %{price_when_carted: "456.7", quantity: 43}

      assert {:ok, %CartItem{} = cart_items} = ShoppingCart.update_cart_items(cart_items, update_attrs)
      assert cart_items.price_when_carted == Decimal.new("456.7")
      assert cart_items.quantity == 43
    end

    test "update_cart_items/2 with invalid data returns error changeset" do
      cart_items = cart_items_fixture()
      assert {:error, %Ecto.Changeset{}} = ShoppingCart.update_cart_items(cart_items, @invalid_attrs)
      assert cart_items == ShoppingCart.get_cart_items!(cart_items.id)
    end

    test "delete_cart_items/1 deletes the cart_items" do
      cart_items = cart_items_fixture()
      assert {:ok, %CartItem{}} = ShoppingCart.delete_cart_items(cart_items)
      assert_raise Ecto.NoResultsError, fn -> ShoppingCart.get_cart_items!(cart_items.id) end
    end

    test "change_cart_items/1 returns a cart_items changeset" do
      cart_items = cart_items_fixture()
      assert %Ecto.Changeset{} = ShoppingCart.change_cart_items(cart_items)
    end
  end
end
