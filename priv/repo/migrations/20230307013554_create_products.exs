defmodule DigistabStore.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :price, :integer
      add :promotional_price, :integer
      add :stock, :integer
      add :description, :text

      timestamps()
    end
  end
end
