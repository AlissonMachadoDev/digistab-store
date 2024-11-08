defmodule DigistabStore.Store.ProductTag do
  @moduledoc """
  Join schema between products and tags. Manages the many-to-many relationship
  allowing products to be tagged and filtered by multiple criteria.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias DigistabStore.Store.Product
  alias DigistabStore.Store.Tag
  alias __MODULE__

  @typedoc """
  Join table type for products and tags.

  Fields:
  - :id - Unique identifier
  - :product_id - Associated product ID
  - :tag_id - Associated tag ID
  """
  @type t :: %ProductTag{
          id: binary(),
          product_id: binary(),
          tag_id: binary(),
          product: %Product{} | nil,
          tag: %Tag{} | nil,
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

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
