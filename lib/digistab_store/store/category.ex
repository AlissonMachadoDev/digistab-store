defmodule DigistabStore.Store.Category do
  @moduledoc """
  Defines product categories.

  Supports a hierarchical structure where categories can have subcategories,
  allowing for better product organization and navigation.
  """
  alias DigistabStore.Store.Product
  use Ecto.Schema
  import Ecto.Changeset

  @typedoc """
  Category type for product organization.

  Fields:
  - :id - Unique identifier
  - :name - Category name
  - :description - Category description
  - :products - Products in this category (has_many)
  - :category - Parent category (belongs_to)
  - :sub_categories - Child categories (has_many)
  """
  @type t :: %__MODULE__{
          id: binary(),
          name: String.t(),
          description: String.t(),
          category_id: binary() | nil,
          products: [%Product{}] | nil,
          category: t() | nil,
          sub_categories: [t()] | nil,
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "categories" do
    field :description, :string
    field :name, :string

    has_many :products, Product

    belongs_to :category, __MODULE__
    has_many :sub_categories, __MODULE__

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
