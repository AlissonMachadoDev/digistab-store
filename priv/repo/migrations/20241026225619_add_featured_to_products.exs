defmodule DigistabStore.Repo.Migrations.AddFeaturedToProducts do
  use Ecto.Migration

  # This new field is for mark a product to be highlighted by the system.
  def change do
    alter table(:products) do
      add :featured?, :boolean, default: false, null: false
    end
  end
end
