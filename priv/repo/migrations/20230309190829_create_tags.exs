defmodule DigistabStore.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :tag_type_id, references(:tag_types, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:tags, [:tag_type_id])
  end
end
