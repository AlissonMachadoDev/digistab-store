defmodule DigistabStore.Repo.Migrations.AddCategoryToProduct do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :category_id, references(:categories, on_delete: :nothing, type: :binary_id)
    end

    create index(:products, [:category_id])
  end
end
