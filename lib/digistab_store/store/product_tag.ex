defmodule DigistabStore.Store.ProductTag do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "products_tags" do
    belongs_to :product, DigistabStore.Store.Product
    belongs_to :tag, DigistabStore.Store.Tag

    timestamps()
  end

  def changeset(product_tag, attrs) do
    product_tag
    |> cast(attrs, [:product_id, :tag_id])
    |> validate_required([:product_id, :tag_id])
    |> unique_constraint([:product_id, :tag_id])
  end
end
