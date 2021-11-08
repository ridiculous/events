defmodule LavaWeb.CartView do
  use LavaWeb, :view

  alias Lava.ShoppingCart

  def currency_to_str(%Decimal{} = val), do: "$#{Decimal.round(val, 2)}"
end
