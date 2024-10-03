defmodule DigistabStore.Repo.Migrations.CreateProductsCategories do
  use Ecto.Migration

  def change do
    create table(:products_categories, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :product_id, references(:products, on_delete: :nothing, type: :binary_id)
      add :category_id, references(:categories, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:products_categories, [:product_id])
    create index(:products_categories, [:category_id])
  end
end
