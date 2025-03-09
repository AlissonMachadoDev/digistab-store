defmodule DigistabStore.Factory do
  @moduledoc """
  Factory definitions for test data generation using ExMachina.
  """
  use ExMachina.Ecto, repo: DigistabStore.Repo

  alias DigistabStore.Store.{
    Product,
    Category,
    Status,
    TagType,
    Tag,
    ProductPhoto
  }

  def status_factory do
    %Status{
      name: sequence(:name, &"Status #{&1}"),
      description: sequence(:description, &"Description for status #{&1}")
    }
  end

  def category_factory do
    %Category{
      name: sequence(:name, &"Category #{&1}"),
      description: sequence(:description, &"Description for category #{&1}"),
      category_id: nil
    }
  end

  def tag_type_factory do
    %TagType{
      name: sequence(:name, &"Tag Type #{&1}")
    }
  end

  def tag_factory do
    %Tag{
      name: sequence(:name, &"Tag #{&1}"),
      tag_type: build(:tag_type)
    }
  end

  def product_tag_factory do
    %DigistabStore.Store.ProductTag{
      product_id: build(:product).id,
      tag_id: build(:tag).id
    }
  end

  def product_photo_factory do
    %ProductPhoto{
      url: sequence(:url, &"https://example.com/photo_#{&1}.jpg"),
      description: sequence(:description, &"Photo description #{&1}"),
      main?: false,
      product: build(:product)
    }
  end

  def product_factory do
    %Product{
      name: sequence(:name, &"Product #{&1}"),
      description: sequence(:description, &"Detailed description for product #{&1}"),
      price: sequence(:price, &(&1 * 1000)),
      promotional_price: sequence(:promotional_price, &(&1 * 900)),
      stock: sequence(:stock, &(&1 * 10)),
      featured?: false,
      status_id: insert(:status).id,
      category_id: insert(:category).id,
      photos: [],
      tags: []
    }
  end

  def product_with_photos_factory do
    struct!(
      product_factory(),
      %{
        photos: build_list(3, :product_photo)
      }
    )
  end

  def featured_product_factory do
    struct!(
      product_factory(),
      %{
        featured?: true,
        photos: build_list(2, :product_photo)
      }
    )
  end

  def product_with_tags_factory do
    struct!(
      product_factory(),
      %{
        tags: build_list(3, :tag)
      }
    )
  end

  def complete_product_factory do
    insert(:product)
    |> with_photos()
    |> with_tags()
  end

  def with_photos(product) do
    photos = build_list(3, :product_photo, product: product)
    %{product | photos: photos}
  end

  def insert_with_photos(product) do
    photos = insert_list(3, :product_photo, product: product)
    %{product | photos: photos}
  end

  def with_tags(product) do
    tags = insert_list(3, :tag)
    %{product | tags: tags}
  end

  def insert_with_tags(product) do
    tags = insert_list(3, :tag)

    Enum.each(tags, fn tag ->
      insert(:product_tag, product_id: product.id, tag_id: tag.id)
    end)

    %{product | tags: tags}
  end
end
