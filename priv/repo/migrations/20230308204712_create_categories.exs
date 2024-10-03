defmodule DigistabStore.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :category_id, references(:categories, on_delete: :nothing, type: :binary_id)
      add :name, :string
      add :description, :string

      timestamps()
    end
  end
end
