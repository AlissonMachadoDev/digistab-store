defmodule DigistabStore.ProductTagTest do
  use DigistabStore.DataCase, async: true

  import DigistabStore.Factory

  alias DigistabStore.Store
  alias DigistabStore.Store.ProductTag

  describe "products_tags" do
    setup do
      product = insert(:product)
      tag = insert(:tag)
      valid_attrs = %{product_id: product.id, tag_id: tag.id}

      {:ok, product: product, tag: tag, valid_attrs: valid_attrs}
    end

    test "list_products_tags/0 returns all product_tags", %{
      product: product,
      tag: tag,
      valid_attrs: valid_attrs
    } do
      {:ok, product_tag} = Store.create_product_tag(valid_attrs)
      assert Enum.map(Store.list_products_tags(), & &1.id) |> Enum.member?(product_tag.id)
    end

    test "get_product_tag!/1 returns the product_tag with given id", %{valid_attrs: valid_attrs} do
      {:ok, product_tag} = Store.create_product_tag(valid_attrs)
      assert Store.get_product_tag!(product_tag.id).id == product_tag.id
    end

    test "create_product_tag/1 with valid data creates a product_tag", %{
      product: product,
      tag: tag
    } do
      valid_attrs = %{product_id: product.id, tag_id: tag.id}

      assert {:ok, %ProductTag{} = product_tag} = Store.create_product_tag(valid_attrs)
      assert product_tag.product_id == product.id
      assert product_tag.tag_id == tag.id
    end

    test "create_product_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Store.create_product_tag(%{product_id: nil})
    end

    test "update_product_tag/2 with valid data updates the product_tag", %{
      valid_attrs: valid_attrs
    } do
      {:ok, product_tag} = Store.create_product_tag(valid_attrs)
      new_tag = insert(:tag)
      update_attrs = %{tag_id: new_tag.id}

      assert {:ok, %ProductTag{} = updated_product_tag} =
               Store.update_product_tag(product_tag, update_attrs)

      assert updated_product_tag.tag_id == new_tag.id
    end

    test "update_product_tag/2 with invalid data returns error changeset", %{
      valid_attrs: valid_attrs
    } do
      {:ok, product_tag} = Store.create_product_tag(valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Store.update_product_tag(product_tag, %{tag_id: nil})
      assert product_tag.id == Store.get_product_tag!(product_tag.id).id
    end

    test "delete_product_tag/1 deletes the product_tag", %{valid_attrs: valid_attrs} do
      {:ok, product_tag} = Store.create_product_tag(valid_attrs)
      assert {:ok, %ProductTag{}} = Store.delete_product_tag(product_tag)
      assert_raise Ecto.NoResultsError, fn -> Store.get_product_tag!(product_tag.id) end
    end

    test "change_product_tag/1 returns a product_tag changeset", %{valid_attrs: valid_attrs} do
      {:ok, product_tag} = Store.create_product_tag(valid_attrs)
      assert %Ecto.Changeset{} = Store.change_product_tag(product_tag)
    end

    test "change_product_tag/2 with valid attributes returns a valid changeset", %{
      valid_attrs: valid_attrs
    } do
      {:ok, product_tag} = Store.create_product_tag(valid_attrs)
      new_tag = insert(:tag)
      changeset = Store.change_product_tag(product_tag, %{tag_id: new_tag.id})
      assert changeset.valid?
    end

    test "change_product_tag/2 with invalid attributes returns an invalid changeset", %{
      valid_attrs: valid_attrs
    } do
      {:ok, product_tag} = Store.create_product_tag(valid_attrs)
      changeset = Store.change_product_tag(product_tag, %{tag_id: nil})
      refute changeset.valid?
    end
  end
end
