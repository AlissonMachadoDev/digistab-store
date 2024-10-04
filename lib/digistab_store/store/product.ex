defmodule DigistabStore.Store.Product do
  use Ecto.Schema
  import Ecto.Changeset

  alias DigistabStore.Store
  alias Store.Status
  alias Store.Category
  alias Store.ProductPhoto

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "products" do
    field :description, :string
    field :name, :string
    field :price, :integer
    field :promotional_price, :integer
    field :stock, :integer, default: 0

    field :status_name, :string, virtual: true
    field :category_name, :string, virtual: true

    belongs_to :status, Status, on_replace: :delete
    belongs_to :category, Category, on_replace: :delete

    has_many :photos, ProductPhoto

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [
      :name,
      :price,
      :promotional_price,
      :description,
      :stock,
      :status_id,
      :category_id
    ])
    |> validate_required([:name, :price, :promotional_price, :description])
    |> validate_number(:stock, greater_than_or_equal_to: 0)
    |> cast_assoc(:status)
    |> cast_assoc(:category)
    |> cast_assoc(:photos)
  end
end
