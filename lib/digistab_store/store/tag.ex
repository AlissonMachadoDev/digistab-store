defmodule DigistabStore.Store.Tag do
  alias DigistabStore.Store.TagType
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tags" do
    field :name, :string

    belongs_to :tag_type, TagType

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name, :tag_type_id])
    |> cast_assoc(:tag_type)
    |> validate_required([:name])
  end
end
