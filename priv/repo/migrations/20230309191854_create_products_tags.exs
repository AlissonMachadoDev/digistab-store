defmodule DigistabStore.Repo.Migrations.CreateProductsTags do
  use Ecto.Migration

  # This migration was later removed by up() and down() in another migration. This is table is never used.
  def change do
    create table(:products_tags, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :product_id, references(:products, on_delete: :nothing, type: :binary_id)
      add :tag_id, references(:tags, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:products_tags, [:product_id])
    create index(:products_tags, [:tag_id])
  end
end
