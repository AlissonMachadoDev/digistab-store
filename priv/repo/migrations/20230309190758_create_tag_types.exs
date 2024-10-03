defmodule DigistabStore.Repo.Migrations.CreateTagTypes do
  use Ecto.Migration

  def change do
    create table(:tag_types, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string

      timestamps()
    end
  end
end
