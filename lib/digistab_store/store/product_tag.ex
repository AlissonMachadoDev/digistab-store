defmodule DigistabStore.Store.ProductTag do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "products_tags" do
    field :product_id, :binary_id
    field :tag_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(product_tag, attrs) do
    product_tag
    |> cast(attrs, [])
    |> validate_required([])
  end
end
