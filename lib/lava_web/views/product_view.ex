defmodule LavaWeb.ProductView do
  use LavaWeb, :view

  def category_select(f, changeset) do
    existing_ids = changeset |> Ecto.Changeset.get_field(:categories) |> Enum.map(& &1.id)

    category_opts =
    for cat <- Lava.Catalog.list_categories(),
        do: [key: cat.title, value: cat.id, selected: cat.id in existing_ids]

    multiple_select(f, :category_ids, category_opts)
  end
end
