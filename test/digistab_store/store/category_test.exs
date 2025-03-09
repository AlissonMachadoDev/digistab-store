defmodule DigistabStore.Store.CategoryTest do
  use DigistabStore.DataCase, async: true

  import DigistabStore.Factory

  alias DigistabStore.Store
  alias DigistabStore.Store.Category

  describe "categories" do
    test "list_categories/0 returns all categories" do
      category = insert(:category)
      assert Enum.map(Store.list_categories(), & &1.id) |> Enum.member?(category.id)
    end

    test "get_category!/1 returns the category with given id" do
      category = insert(:category)
      assert Store.get_category!(category.id).id == category.id
    end

    test "create_category/1 with valid data creates a category" do
      valid_attrs = %{name: "Electronics", description: "Electronic devices and gadgets"}

      assert {:ok, %Category{} = category} = Store.create_category(valid_attrs)
      assert category.name == "Electronics"
      assert category.description == "Electronic devices and gadgets"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Store.create_category(%{name: nil})
    end

    test "update_category/2 with valid data updates the category" do
      category = insert(:category)
      update_attrs = %{name: "Updated Category Name"}

      assert {:ok, %Category{} = updated_category} =
               Store.update_category(category, update_attrs)

      assert updated_category.name == "Updated Category Name"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = insert(:category)
      assert {:error, %Ecto.Changeset{}} = Store.update_category(category, %{name: nil})
      assert category.id == Store.get_category!(category.id).id
    end

    test "delete_category/1 deletes the category" do
      category = insert(:category)
      assert {:ok, %Category{}} = Store.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Store.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = insert(:category)
      assert %Ecto.Changeset{} = Store.change_category(category)
    end

    test "change_category/2 with valid attributes returns a valid changeset" do
      category = insert(:category)
      valid_attrs = %{name: "New Category", description: "New Description"}
      changeset = Store.change_category(category, valid_attrs)
      assert changeset.valid?
    end

    test "change_category/2 with invalid attributes returns an invalid changeset" do
      category = insert(:category)
      invalid_attrs = %{name: nil}
      changeset = Store.change_category(category, invalid_attrs)
      refute changeset.valid?
    end
  end
end
