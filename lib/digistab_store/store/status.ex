defmodule DigistabStore.Store.Status do
  alias DigistabStore.Store.Product
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "status_collection" do
    field :description, :string
    field :name, :string

    has_many :products, Product

    timestamps()
  end

  @doc false
  def changeset(status, attrs) do
    status
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
