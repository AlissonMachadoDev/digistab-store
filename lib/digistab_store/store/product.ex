defmodule DigistabStore.Store.Product do
  use Ecto.Schema
  import Ecto.Changeset

  alias DigistabStore.Store
  alias Store.Status
  alias Store.Category
  alias Store.ProductPhoto
  alias Store.ProductTag
  alias Store.Tag

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "products" do
    field :description, :string
    field :name, :string
    field :price, :integer
    field :promotional_price, :integer
    field :stock, :integer, default: 0
    field :featured?, :boolean, default: false

    field :status_name, :string, virtual: true
    field :category_name, :string, virtual: true

    belongs_to :status, Status, foreign_key: :status_id, on_replace: :delete
    belongs_to :category, Category, foreign_key: :category_id, on_replace: :delete

    has_many :photos, ProductPhoto, on_replace: :delete

    many_to_many :tags, Tag,
      join_through: ProductTag,
      on_replace: :delete,
      unique: true,
      join_keys: [product_id: :id, tag_id: :id]

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    IO.inspect(product: product, attrs: attrs)

    product
    |> cast(attrs, [
      :name,
      :price,
      :promotional_price,
      :description,
      :stock,
      :status_id,
      :category_id,
      :featured?
    ])
    |> validate_required([:name, :price, :promotional_price, :description])
    |> validate_number(:stock, greater_than_or_equal_to: 0)
    |> change_photos(attrs["photos"] || attrs[:photos])
    |> validate_number(:stock, greater_than_or_equal_to: 0)
    |> change_tags(attrs["tags"] || attrs[:tags] || [])
  end

  def change_photos(changeset, []), do: changeset

  def change_photos(changeset, photos) when is_list(photos) do
    changeset
    |> cast_assoc(:photos, with: &ProductPhoto.changeset/2)
  end

  def change_photos(changeset, _), do: changeset

  def change_tags(changeset, []), do: changeset

  def change_tags(changeset, tags) when is_list(tags) do
    changeset
    |> put_assoc(:tags, tags)
  end

  def change_tags(changeset, _), do: changeset
end
