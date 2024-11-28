defmodule DigistabStore.Store.Product do
  @moduledoc """
  Used to store and manage product information including pricing,
  stock levels, and categorization. Products can be featured, have a rich HTML description and
  have promotional prices.
  """

  @typedoc """
  Product type with all main fields.

  Fields:
  - :id - Unique identifier
  - :name - Product name
  - :description - Detailed product description
  - :price - Regular price in cents
  - :promotional_price - Special price in cents
  - :stock - Current inventory count
  - :featured? - Whether product should be featured on the homepage
  - :status - Current product status
  - :category - Product category
  - :photos - Associated product images
  - :tags - Associated product tags
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias DigistabStore.Store
  alias Store.Status
  alias Store.Category
  alias Store.ProductPhoto
  alias Store.ProductTag
  alias Store.Tag

  @type t :: %__MODULE__{
          id: binary(),
          name: String.t(),
          description: String.t(),
          price: integer(),
          promotional_price: integer(),
          stock: non_neg_integer(),
          featured?: boolean(),
          status: Status.t(),
          category: Category.t(),
          photos: [ProductPhoto.t()],
          tags: [Tag.t()]
        }
  @required [:name, :price, :promotional_price, :description, :category_id, :status_id]
  # , :release_date
  @optional [:stock, :featured?]

  @max_photos 5

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
      on_delete: :delete_all,
      unique: true,
      join_keys: [product_id: :id, tag_id: :id]

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
    |> validate_length(:name, min: 3, max: 255)
    |> validate_length(:description, min: 10)
    |> validate_prices()
    |> validate_stock()
    |> validate_status()
    |> validate_category()
    |> validate_photos()
    |> change_photos(attrs["photos"] || attrs[:photos])
    |> change_tags(attrs["tags"] || attrs[:tags] || [])
  end

  @doc """
  Changeset function to handle photo changes.
  """
  def change_photos(%Ecto.Changeset{} = changeset, []), do: changeset

  def change_photos(%Ecto.Changeset{} = changeset, photos) when is_list(photos) do
    changeset
    |> cast_assoc(:photos, with: &ProductPhoto.changeset/2)
  end

  def change_photos(%Ecto.Changeset{} = changeset, _), do: changeset

  def change_tags(%Ecto.Changeset{} = changeset, []), do: changeset

  def change_tags(%Ecto.Changeset{} = changeset, tags) when is_list(tags) do
    changeset
    |> put_assoc(:tags, tags)
  end

  def change_tags(%Ecto.Changeset{} = changeset, _), do: changeset

  @doc """
  Validates product prices and promotional prices.
  Makes sure promotional price is less than the regular price.
  """
  def validate_prices(%Ecto.Changeset{} = changeset) do
    changeset
    |> validate_number(:price, greater_than: 0)
    |> validate_number(:promotional_price, greater_than_or_equal_to: 0)
    |> validate_promotional_price()
  end

  def validate_stock(%Ecto.Changeset{} = changeset) do
    changeset
    |> validate_number(:stock, greater_than_or_equal_to: 0)
  end

  def validate_status(%Ecto.Changeset{} = changeset) do
    changeset
    |> validate_required([:status_id])
  end

  def validate_category(%Ecto.Changeset{} = changeset) do
    changeset
    |> validate_required([:category_id])
  end

  def validate_photos(%Ecto.Changeset{} = changeset) do
    changeset
    |> validate_max_photos()
  end

  defp validate_promotional_price(%Ecto.Changeset{} = changeset) do
    price = get_field(changeset, :price)
    promo_price = get_field(changeset, :promotional_price)

    with true <- not is_nil(price) and not is_nil(promo_price),
         true <- promo_price < price do
      changeset
    else
      false ->
        add_error(changeset, :promotional_price, "invalid promotional price")
    end
  end

  defp validate_max_photos(%Ecto.Changeset{} = changeset) do
    photos = get_field(changeset, :photos) || []

    if length(photos) <= @max_photos,
      do: changeset,
      else: add_error(changeset, :photos, "maximum #{@max_photos} photos allowed")
  end
end
