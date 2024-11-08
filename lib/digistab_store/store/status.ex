defmodule DigistabStore.Store.Status do
  @moduledoc """
  Tracks product availability status.

  Common statuses include: Active, Out of Stock, Discontinued, and Coming Soon.
  Used to control whether products are available for purchase.
  """
  alias DigistabStore.Store.Product
  alias __MODULE__
  use Ecto.Schema
  import Ecto.Changeset

  @typedoc """
  Status type for product availability states.

  Fields:
  - :id - Unique identifier
  - :name - Status name (e.g., "Active", "Out of Stock")
  - :description - Status description
  - :products - Products with this status (has_many)
  """
  @type t :: %Status{
          id: binary(),
          name: String.t(),
          description: String.t(),
          products: [%Product{}] | nil,
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

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
