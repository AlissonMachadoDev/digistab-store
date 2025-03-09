defmodule DigistabStore.Store.StatusTest do
  use DigistabStore.DataCase, async: true

  import DigistabStore.Factory

  alias DigistabStore.Store
  alias DigistabStore.Store.Status

  describe "status_collection" do
    test "list_status_collection/0 returns all statuses" do
      status = insert(:status)
      assert Enum.map(Store.list_status_collection(), & &1.id) |> Enum.member?(status.id)
    end

    test "get_status!/1 returns the status with given id" do
      status = insert(:status)
      assert Store.get_status!(status.id).id == status.id
    end

    test "create_status/1 with valid data creates a status" do
      valid_attrs = %{name: "Active", description: "Product is available"}

      assert {:ok, %Status{} = status} = Store.create_status(valid_attrs)
      assert status.name == "Active"
      assert status.description == "Product is available"
    end

    test "create_status/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Store.create_status(%{name: nil})
    end

    test "update_status/2 with valid data updates the status" do
      status = insert(:status)
      update_attrs = %{name: "Updated Status"}

      assert {:ok, %Status{} = updated_status} =
               Store.update_status(status, update_attrs)

      assert updated_status.name == "Updated Status"
    end

    test "update_status/2 with invalid data returns error changeset" do
      status = insert(:status)
      assert {:error, %Ecto.Changeset{}} = Store.update_status(status, %{name: nil})
      assert status.id == Store.get_status!(status.id).id
    end

    test "delete_status/1 deletes the status" do
      status = insert(:status)
      assert {:ok, %Status{}} = Store.delete_status(status)
      assert_raise Ecto.NoResultsError, fn -> Store.get_status!(status.id) end
    end

    test "change_status/1 returns a status changeset" do
      status = insert(:status)
      assert %Ecto.Changeset{} = Store.change_status(status)
    end

    test "change_status/2 with valid attributes returns a valid changeset" do
      status = insert(:status)
      valid_attrs = %{name: "New Status", description: "New Description"}
      changeset = Store.change_status(status, valid_attrs)
      assert changeset.valid?
    end

    test "change_status/2 with invalid attributes returns an invalid changeset" do
      status = insert(:status)
      invalid_attrs = %{name: nil}
      changeset = Store.change_status(status, invalid_attrs)
      refute changeset.valid?
    end
  end
end
