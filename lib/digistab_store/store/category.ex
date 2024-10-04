defmodule DigistabStore.Store.Category do
  alias DigistabStore.Store.Product
  use Ecto.Schema
  import Ecto.Changeset

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
