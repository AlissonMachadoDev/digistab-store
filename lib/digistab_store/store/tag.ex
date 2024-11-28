defmodule DigistabStore.Store.Tag do
  @moduledoc """
  Product tagging system.

  Tags help organize and filter products by characteristics like color, size,
  or material. Each tag belongs to a specific tag type.
  """
  alias DigistabStore.Store
  alias Store.Product
  alias Store.ProductTag
  alias Store.TagType
  alias __MODULE__
  use Ecto.Schema
  import Ecto.Changeset

  @typedoc """
  Tag type for product labeling.

  Fields:
  - :id - Unique identifier
  - :name - Tag name
  - :tag_type - Type of tag (belongs_to)
  - :products - Products with this tag (many_to_many)
  """
  @type t :: %Tag{
          id: binary(),
          name: String.t(),
          tag_type_id: binary(),
          tag_type: %Tag{} | nil,
          products: [%Product{}] | nil,
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tags" do
    field :name, :string

    belongs_to :tag_type, TagType

    many_to_many :products, Product,
      join_through: ProductTag,
      on_replace: :delete,
      join_keys: [tag_id: :id, product_id: :id]

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name, :tag_type_id])
    |> cast_assoc(:tag_type)
    |> validate_required([:name])
  end
end
