defmodule DigistabStore.Store.TagType do
  alias DigistabStore.Store.Tag
  use Ecto.Schema
  import Ecto.Changeset

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
