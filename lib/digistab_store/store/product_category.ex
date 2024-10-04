defmodule DigistabStore.Store.ProductCategory do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "products_categories" do
    field :product_id, :binary_id
    field :category_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(product_category, attrs) do
    product_category
    |> cast(attrs, [])
    |> validate_required([])
  end
end
