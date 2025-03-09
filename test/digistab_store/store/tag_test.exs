defmodule DigistabStore.Store.TagTest do
  use DigistabStore.DataCase, async: true

  import DigistabStore.Factory

  alias DigistabStore.Store
  alias DigistabStore.Store.Tag
  alias DigistabStore.Store.TagType

  describe "tags" do
    test "list_tags/0 returns all tags with tag_type preloaded" do
      tag = insert(:tag)
      listed_tags = Store.list_tags()

      assert Enum.find(listed_tags, &(&1.id == tag.id)) != nil

      result_tag = Enum.find(listed_tags, &(&1.id == tag.id))
      assert result_tag.tag_type != nil
      assert result_tag.tag_type.id != nil
    end

    test "get_tag!/1 returns the tag with given id" do
      tag = insert(:tag)
      assert Store.get_tag!(tag.id).id == tag.id
    end

    test "create_tag/1 with valid data creates a tag" do
      tag_type = insert(:tag_type)
      valid_attrs = %{name: "Red", tag_type_id: tag_type.id}

      assert {:ok, %Tag{} = tag} = Store.create_tag(valid_attrs)
      assert tag.name == "Red"
      assert tag.tag_type_id == tag_type.id
    end

    test "create_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Store.create_tag(%{name: nil})
    end

    test "update_tag/2 with valid data updates the tag" do
      tag = insert(:tag)
      update_attrs = %{name: "Updated Tag Name"}

      assert {:ok, %Tag{} = updated_tag} = Store.update_tag(tag, update_attrs)
      assert updated_tag.name == "Updated Tag Name"
    end

    test "update_tag/2 with invalid data returns error changeset" do
      tag = insert(:tag)
      assert {:error, %Ecto.Changeset{}} = Store.update_tag(tag, %{name: nil})
      assert tag.id == Store.get_tag!(tag.id).id
    end

    test "delete_tag/1 deletes the tag" do
      tag = insert(:tag)
      assert {:ok, %Tag{}} = Store.delete_tag(tag)
      assert_raise Ecto.NoResultsError, fn -> Store.get_tag!(tag.id) end
    end

    test "change_tag/1 returns a tag changeset" do
      tag = insert(:tag)
      assert %Ecto.Changeset{} = Store.change_tag(tag)
    end

    test "change_tag/2 with valid attributes returns a valid changeset" do
      tag = insert(:tag)
      valid_attrs = %{name: "New Tag"}
      changeset = Store.change_tag(tag, valid_attrs)
      assert changeset.valid?
    end

    test "change_tag/2 with invalid attributes returns an invalid changeset" do
      tag = insert(:tag)
      invalid_attrs = %{name: nil}
      changeset = Store.change_tag(tag, invalid_attrs)
      refute changeset.valid?
    end
  end

  describe "tag_types" do
    test "list_tag_types/0 returns all tag types" do
      tag_type = insert(:tag_type)
      assert Enum.map(Store.list_tag_types(), & &1.id) |> Enum.member?(tag_type.id)
    end

    test "get_tag_type!/1 returns the tag_type with given id" do
      tag_type = insert(:tag_type)
      assert Store.get_tag_type!(tag_type.id).id == tag_type.id
    end

    test "create_tag_type/1 with valid data creates a tag_type" do
      valid_attrs = %{name: "Color"}

      assert {:ok, %TagType{} = tag_type} = Store.create_tag_type(valid_attrs)
      assert tag_type.name == "Color"
    end

    test "create_tag_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Store.create_tag_type(%{name: nil})
    end

    test "update_tag_type/2 with valid data updates the tag_type" do
      tag_type = insert(:tag_type)
      update_attrs = %{name: "Updated TagType"}

      assert {:ok, %TagType{} = updated_tag_type} =
               Store.update_tag_type(tag_type, update_attrs)

      assert updated_tag_type.name == "Updated TagType"
    end

    test "update_tag_type/2 with invalid data returns error changeset" do
      tag_type = insert(:tag_type)
      assert {:error, %Ecto.Changeset{}} = Store.update_tag_type(tag_type, %{name: nil})
      assert tag_type.id == Store.get_tag_type!(tag_type.id).id
    end

    test "delete_tag_type/1 deletes the tag_type" do
      tag_type = insert(:tag_type)
      assert {:ok, %TagType{}} = Store.delete_tag_type(tag_type)
      assert_raise Ecto.NoResultsError, fn -> Store.get_tag_type!(tag_type.id) end
    end

    test "change_tag_type/1 returns a tag_type changeset" do
      tag_type = insert(:tag_type)
      assert %Ecto.Changeset{} = Store.change_tag_type(tag_type)
    end

    test "change_tag_type/2 with valid attributes returns a valid changeset" do
      tag_type = insert(:tag_type)
      valid_attrs = %{name: "New TagType"}
      changeset = Store.change_tag_type(tag_type, valid_attrs)
      assert changeset.valid?
    end

    test "change_tag_type/2 with invalid attributes returns an invalid changeset" do
      tag_type = insert(:tag_type)
      invalid_attrs = %{name: nil}
      changeset = Store.change_tag_type(tag_type, invalid_attrs)
      refute changeset.valid?
    end
  end
end
