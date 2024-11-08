defmodule DigistabStore.Store.ProductPhoto do
  @moduledoc """
  Manages product photos stored in S3.

  Each product can have up to 5 photos, with one marked as the main display image.
  Photos include descriptions for accessibility.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias DigistabStore.Store
  alias Store.Product

  @typedoc """
  Product photo type for product images.

  Fields:
  - :id - Unique identifier
  - :url - S3 URL for the image
  - :description - Image description or alt text
  - :main? - Whether this is the main product photo
  - :product - Associated product (belongs_to)
  """
  @type t :: %__MODULE__{
          id: binary(),
          url: String.t(),
          description: String.t() | nil,
          main?: boolean(),
          product_id: binary(),
          product: %Product{} | nil,
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

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
