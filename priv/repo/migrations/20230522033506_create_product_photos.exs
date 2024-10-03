defmodule DigistabStore.Repo.Migrations.CreateProductPhotos do
  use Ecto.Migration

  def change do
    create table(:product_photos, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :url, :string
      add :description, :string
      add :main?, :boolean, default: false, null: false
      add :product_id, references(:products, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:product_photos, [:product_id])
  end
end
