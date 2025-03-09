defmodule DigistabStore.Store.ProductTest do
  use DigistabStore.DataCase, async: true

  import DigistabStore.Factory

  alias DigistabStore.Store
  alias DigistabStore.Store.Product

  describe "products" do
    test "list_products/0 returns all products" do
      product =
        insert(:product)
        |> Store.preload_product!()

      assert Store.list_products(true) == [product]
    end

    test "list_featured_products/0 returns only featured products" do
      featured_product = insert(:product, featured?: true)

      featured_product =
        featured_product
        |> with_photos()
        |> with_tags()
        |> Repo.preload([:photos, :tags, :status, :category])

      _non_featured = insert(:product)

      featured_products = Store.list_featured_products()

      assert length(featured_products) == 1
      assert hd(featured_products).id == featured_product.id
    end

    test "get_product!/1 returns the product with given id" do
      product =
        insert(:product)
        |> Store.preload_product!()

      assert Store.get_product!(product.id, true) == product
    end

    test "create_product/1 with valid data creates a product" do
      status = insert(:status)
      category = insert(:category)

      valid_attrs =
        params_for(:product, %{
          status_id: status.id,
          category_id: category.id,
          name: "Test Product",
          price: 10000,
          promotional_price: 9000,
          stock: 10,
          featured?: false
        })

      assert {:ok, %Product{} = product} = Store.create_product(valid_attrs)
      assert product.name == "Test Product"
      assert product.price == 10000
      assert product.stock == 10
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Store.create_product(%{})
    end

    test "update_product/2 with valid data updates the product" do
      product = insert(:product)
      update_attrs = %{name: "Updated Name"}

      assert {:ok, %Product{} = updated_product} =
               Store.update_product(product, update_attrs)

      assert updated_product.name == "Updated Name"
    end

    test "delete_product/1 deletes the product" do
      product = insert(:product)
      assert {:ok, %Product{}} = Store.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Store.get_product!(product.id) end
    end

    test "search_products/1 returns products matching the search term" do
      product1 = insert(:product, name: "Smartphone iPhone 12")
      product2 = insert(:product, name: "Smartphone Samsung Galaxy")
      _product3 = insert(:product, name: "Laptop")

      results = Store.search_products("phone")

      assert length(results) == 2

      assert Enum.map(results, & &1.id) |> Enum.sort() ==
               [product1.id, product2.id] |> Enum.sort()
    end

    test "complete product creation with associations" do
      product = insert(:product)

      product =
        product
        |> with_photos()
        |> with_tags()
        |> Repo.preload([:photos, :tags, :status, :category])

      assert product.photos != []
      assert product.tags != []
      assert product.status != nil
      assert product.category != nil
    end
  end

  test "list_products/1 with preload true returns all products with associations" do
    product = insert(:product)
    product = product |> insert_with_photos() |> insert_with_tags()

    result =
      Store.list_products(true)

    found_product = Enum.find(result, fn p -> p.id == product.id end)

    assert found_product.tags != []
    assert found_product.status != nil
    assert found_product.category != nil
    assert found_product.photos != []
  end

  test "preload_product!/1 preloads associations for a product" do
    product = insert(:product)

    product = product |> insert_with_photos() |> insert_with_tags()

    fresh_product = Store.get_product!(product.id)

    preloaded = Store.preload_product!(fresh_product)

    assert preloaded.photos != []
    assert preloaded.tags != []
    assert preloaded.status != nil
    assert preloaded.category != nil
  end

  test "list_other_products/0 returns non-featured products" do
    non_featured = insert(:product, featured?: false)
    non_featured = non_featured |> with_photos()

    _featured = insert(:product, featured?: true)

    results = Store.list_other_products()

    assert Enum.find(results, fn p -> p.id == non_featured.id end) != nil

    assert Enum.all?(results, fn p -> p.featured? == false end)
  end

  test "mark_as_featured/1 sets featured? to true" do
    product = insert(:product, featured?: false)

    assert {:ok, updated_product} = Store.mark_as_featured(product)
    assert updated_product.featured? == true
  end

  test "list_products_by_category/1 returns products for specific category" do
    category = insert(:category)
    product_in_category = insert(:product, category_id: category.id)
    product_in_category = product_in_category |> with_photos()

    different_category = insert(:category)
    _different_product = insert(:product, category_id: different_category.id)

    results = Store.list_products_by_category(category.id)

    assert length(results) >= 1
    assert Enum.find(results, fn p -> p.id == product_in_category.id end) != nil
    assert Enum.all?(results, fn p -> p.category_id == category.id end)
  end

  test "search_products/1 searches by name" do
    product = insert(:product, name: "Special Product XYZ")

    _other_product = insert(:product, name: "Regular product")

    results = Store.search_products("XYZ")

    assert length(results) >= 1
    assert Enum.find(results, fn p -> p.id == product.id end) != nil
  end

  test "search_products/1 searches by description" do
    product = insert(:product, description: "Contains special XYZ features")

    _other_product = insert(:product, description: "Regular features")

    results = Store.search_products("XYZ")

    assert length(results) >= 1
    assert Enum.find(results, fn p -> p.id == product.id end) != nil
  end

  test "search_products/2 with preload option preloads associations" do
    product = insert(:product, name: "Special Product ABC")
    product = product |> with_photos() |> with_tags()

    results = Store.search_products("ABC", true)

    found_product = Enum.find(results, fn p -> p.id == product.id end)
    assert found_product != nil
    assert found_product.photos != nil
    assert found_product.status != nil
    assert found_product.category != nil
  end
end
