defmodule DigistabStore.Store.TagType do
  @moduledoc """
  Categorizes different kinds of tags.

  Examples include: Color, Size, Material, Brand, and Season.
  Helps maintain organization in the tagging system.
  """
  alias DigistabStore.Store.Tag
  alias __MODULE__
  use Ecto.Schema
  import Ecto.Changeset

  @typedoc """
  Tag type categorization.

  Fields:
  - :id - Unique identifier
  - :name - Type name (e.g., "Color", "Size")
  - :tags - Tags of this type (has_many)
  """
  @type t :: %TagType{
          id: binary(),
          name: String.t(),
          tags: [%Tag{}] | nil,
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tag_types" do
    field :name, :string

    has_many :tags, Tag

    timestamps()
  end

  @doc false
  def changeset(tag_type, attrs) do
    tag_type
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
