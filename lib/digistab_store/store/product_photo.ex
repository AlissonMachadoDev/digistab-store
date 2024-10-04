defmodule DigistabStore.Store.ProductPhoto do
  use Ecto.Schema
  import Ecto.Changeset


  alias DigistabStore.Store
  alias Store.Product

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "product_photos" do
    field :description, :string
    field :main?, :boolean, default: false
    field :url, :string

    belongs_to :product, Product
    timestamps()
  end

  @doc false
  def changeset(product_photo, attrs) do
    product_photo
    |> cast(attrs, [:url, :description, :main?])
    |> validate_required([:url])
  end
end
