defmodule DigistabStore.Repo.Migrations.AddStatusToProduct do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :status_id, references(:status_collection, on_delete: :nothing, type: :binary_id)
    end

    create index(:products, [:status_id])
  end
end
