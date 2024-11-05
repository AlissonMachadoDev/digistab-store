defmodule DigistabStore.Store.Tag do
  alias DigistabStore.Store
  alias Store.Product
  alias Store.ProductTag
  alias Store.TagType
  use Ecto.Schema
  import Ecto.Changeset

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
