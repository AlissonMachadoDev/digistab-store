defmodule DigistabStore.Store do
  @moduledoc """
  The Store context handles all e-commerce functionality for the DigistabStore application.

  ## Architecture

  This context is the core business logic layer, sitting between the web interface
  and the database. It handles with all product-related operations and enforces
  business rules through the data that came from the front.

  ## Key Components

  * Products - Core entity representing sellable items
  * Categories - Hierarchical organization of products
  * Tags - Flexible labeling system for product attributes
  * Status - Product availability states
  * Photos - Product image management

  ## Current Business Rules (Please, update this when something changes)

  * Products can have up to 5 photos
  * Promotional price must be lower than regular price, in case that it's 0, it's considered the regular price
  * Products must belong to exactly one category
  * Products must have at least one status
  * Featured products can be as featured, that it makes them be highlighted in the store frontend, the rest is considered as not featured and are * displayed in the default sections
  """

  import Ecto.Query, warn: false
  alias DigistabStore.Repo

  alias DigistabStore.Store.Category
  alias DigistabStore.Store.Product
  alias DigistabStore.Store.ProductTag
  alias DigistabStore.Store.Status
  alias DigistabStore.Store.TagType
  alias DigistabStore.Store.Tag

  @doc """
  Returns a list of all the products.

  It loads associated data including status, category, and photos.
  the results are ordered by insertion date.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  @spec list_products() :: [Product.t()]
  def list_products do
    Product
    |> order_by([p], p.inserted_at)
    |> Repo.all()
  end

  def list_products(_preload? = true) do
    list_products()
    |> Repo.preload([:status, :category, :photos])
  end

  @doc """
  Returns a list of featured products.

  Featured products are those marked with featured?: true and are
  typically displayed in the store's carousel or highlighted sections.

  ## Examples

      iex> list_featured_products()
      [%Product{featured?: true}, ...]

  """
  @spec list_featured_products() :: [Product.t()]
  def list_featured_products do
    Product
    |> where(featured?: true)
    |> preload([:photos])
    |> Repo.all()
  end

  @doc """
  Returns a list of not featured products.

  These products are those marked with featured?: false and
  typically displayed the default sections of the store.

  ## Examples

      iex> list_other_products()
      [%Product{featured?: false}, ...]

  """
  @spec list_other_products() :: [Product.t()]
  def list_other_products do
    Product
    |> where(featured?: false)
    |> preload([:status, :category, :photos])
    |> Repo.all()
  end

  @doc """
  Returns a list of products that fits on search term.

  ## Examples

      iex> list_other_products()
      [%Product{}, ...]

  """
  @spec search_products(binary()) :: [Product.t()]
  def search_products(product_name) do
    # Just for User Experience
    :timer.sleep(1000)
    search_term = "%#{product_name}%"

    from(p in Product,
      where:
        ilike(p.name, ^search_term) or
          ilike(p.description, ^search_term)
    )
    |> Repo.all()
  end

  def search_products(product_name, _preload? = true) do
    search_products(product_name)
    |> Repo.preload([:status, :category, :photos])
  end

  @doc """
  Returns a list of products that belongs to a category.

  ## Examples

      iex> list_products_by_category()
      [%Product{}, ...]

  """
  @spec list_products_by_category(binary()) :: [Product.t()]
  def list_products_by_category(category_id) do
    Product
    |> where(category_id: ^category_id)
    |> preload([:status, :category, :photos])
    |> Repo.all()
  end

  @doc """
  Updates a product setting the featured option to true.

  ## Examples

      iex> mark_as_featured(product)
      {:ok, %Product{featured?: true}}
  """
  @spec mark_as_featured(Product.t()) :: {:ok, Product.t()} | {:error, Ecto.Changeset.t()}
  def mark_as_featured(%Product{} = product) do
    product
    |> Product.changeset(%{featured?: true})
    |> Repo.update()
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_product!(binary()) :: Product.t() | no_return()
  def get_product!(id) do
    Repo.get!(Product, id)
  end

  def get_product!(id, _preload? = true) do
    get_product!(id)
    |> preload_product!()
  end

  @doc """
   Preload the default fields from the product.

  ## Examples

      iex> preload_product!(product)
      %Product{photos: [...], tags: [...], status: %Status{}, category: %Category{}}

  """
  @spec preload_product!(Product.t()) :: Product.t() | no_return()
  def preload_product!(%Product{} = product) do
    product
    |> Repo.preload([:tags, :status, :photos, :category])
  end

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_product(map()) :: {:ok, Product.t()} | {:error, Ecto.Changeset.t()}
  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_product(Product.t(), map()) :: {:ok, Product.t()} | {:error, Ecto.Changeset.t()}
  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_product(Product.t()) :: {:ok, Product.t()} | {:error, Ecto.Changeset.t()}
  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{data: %Product{}}

  """
  @spec change_product(Product.t(), map()) :: Ecto.Changeset.t()
  def change_product(%Product{} = product, attrs \\ %{}) do
    product
    |> Repo.preload([:status, :category])
    |> Product.changeset(attrs)
  end

  @doc """
  Returns the list of status_collection.

  ## Examples

      iex> list_status_collection()
      [%Status{}, ...]

  """
  @spec list_status_collection() :: [Status.t()]
  def list_status_collection do
    Repo.all(Status)
  end

  @doc """
  Gets a single status.

  Raises `Ecto.NoResultsError` if the Status does not exist.

  ## Examples

      iex> get_status!(123)
      %Status{}

      iex> get_status!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_status!(binary()) :: Status.t() | no_return()
  def get_status!(id), do: Repo.get!(Status, id)

  @doc """
  Creates a status.

  ## Examples

      iex> create_status(%{field: value})
      {:ok, %Status{}}

      iex> create_status(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_status(map()) :: {:ok, Status.t()} | {:error, Ecto.Changeset.t()}
  def create_status(attrs \\ %{}) do
    %Status{}
    |> Status.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a status.

  ## Examples

      iex> update_status(status, %{field: new_value})
      {:ok, %Status{}}

      iex> update_status(status, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_status(Status.t(), map()) :: {:ok, Status.t()} | {:error, Ecto.Changeset.t()}
  def update_status(%Status{} = status, attrs) do
    status
    |> Status.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a status.

  ## Examples

      iex> delete_status(status)
      {:ok, %Status{}}

      iex> delete_status(status)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_status(Status.t()) :: {:ok, Status.t()} | {:error, Ecto.Changeset.t()}
  def delete_status(%Status{} = status) do
    Repo.delete(status)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking status changes.

  ## Examples

      iex> change_status(status)
      %Ecto.Changeset{data: %Status{}}

  """
  @spec change_status(Status.t(), map()) :: Ecto.Changeset.t()
  def change_status(%Status{} = status, attrs \\ %{}) do
    Status.changeset(status, attrs)
  end

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  @spec list_categories() :: [Category.t()]
  def list_categories do
    Repo.all(Category)
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_category!(binary()) :: Category.t() | no_return()
  def get_category!(id), do: Repo.get!(Category, id)

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_category(map()) :: {:ok, Category.t()} | {:error, Ecto.Changeset.t()}
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_category(Category.t(), map()) :: {:ok, Category.t()} | {:error, Ecto.Changeset.t()}
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_category(Category.t()) :: {:ok, Category.t()} | {:error, Ecto.Changeset.t()}
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{data: %Category{}}

  """
  @spec change_category(Category.t(), map()) :: Ecto.Changeset.t()
  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end

  @doc """
  Returns the list of tag_types.

  ## Examples

      iex> list_tag_types()
      [%TagType{}, ...]

  """
  @spec list_tag_types() :: [TagType.t()]
  def list_tag_types do
    Repo.all(TagType)
  end

  @doc """
  Gets a single tag_type.

  Raises `Ecto.NoResultsError` if the Tag type does not exist.

  ## Examples

      iex> get_tag_type!(123)
      %TagType{}

      iex> get_tag_type!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_tag_type!(binary()) :: TagType.t() | no_return()
  def get_tag_type!(id), do: Repo.get!(TagType, id)

  @doc """
  Creates a tag_type.

  ## Examples

      iex> create_tag_type(%{field: value})
      {:ok, %TagType{}}

      iex> create_tag_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_tag_type(map()) :: {:ok, TagType.t()} | {:error, Ecto.Changeset.t()}
  def create_tag_type(attrs \\ %{}) do
    %TagType{}
    |> TagType.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tag_type.

  ## Examples

      iex> update_tag_type(tag_type, %{field: new_value})
      {:ok, %TagType{}}

      iex> update_tag_type(tag_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_tag_type(TagType.t(), map()) :: {:ok, TagType.t()} | {:error, Ecto.Changeset.t()}
  def update_tag_type(%TagType{} = tag_type, attrs) do
    tag_type
    |> TagType.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tag_type.

  ## Examples

      iex> delete_tag_type(tag_type)
      {:ok, %TagType{}}

      iex> delete_tag_type(tag_type)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_tag_type(TagType.t()) :: {:ok, TagType.t()} | {:error, Ecto.Changeset.t()}
  def delete_tag_type(%TagType{} = tag_type) do
    Repo.delete(tag_type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tag_type changes.

  ## Examples

      iex> change_tag_type(tag_type)
      %Ecto.Changeset{data: %TagType{}}

  """
  @spec change_tag_type(TagType.t(), map()) :: Ecto.Changeset.t()
  def change_tag_type(%TagType{} = tag_type, attrs \\ %{}) do
    TagType.changeset(tag_type, attrs)
  end

  @doc """
  Returns the list of tags.

  ## Examples

      iex> list_tags()
      [%Tag{}, ...]

  """
  @spec list_tags() :: [Tag.t()]
  def list_tags do
    Repo.all(Tag)
    |> Repo.preload(:tag_type)
  end

  @doc """
  Gets a single tag.

  Raises `Ecto.NoResultsError` if the Tag does not exist.

  ## Examples

      iex> get_tag!(123)
      %Tag{}

      iex> get_tag!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_tag!(binary()) :: Tag.t() | no_return()
  def get_tag!(id), do: Repo.get!(Tag, id)

  @doc """
  Creates a tag.

  ## Examples

      iex> create_tag(%{field: value})
      {:ok, %Tag{}}

      iex> create_tag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_tag(map()) :: {:ok, Tag.t()} | {:error, Ecto.Changeset.t()}
  def create_tag(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tag.

  ## Examples

      iex> update_tag(tag, %{field: new_value})
      {:ok, %Tag{}}

      iex> update_tag(tag, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_tag(Tag.t(), map()) :: {:ok, Tag.t()} | {:error, Ecto.Changeset.t()}
  def update_tag(%Tag{} = tag, attrs) do
    tag
    |> Tag.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tag.

  ## Examples

      iex> delete_tag(tag)
      {:ok, %Tag{}}

      iex> delete_tag(tag)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_tag(Tag.t()) :: {:ok, Tag.t()} | {:error, Ecto.Changeset.t()}
  def delete_tag(%Tag{} = tag) do
    Repo.delete(tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tag changes.

  ## Examples

      iex> change_tag(tag)
      %Ecto.Changeset{data: %Tag{}}

  """
  @spec change_tag(Tag.t(), map()) :: Ecto.Changeset.t()
  def change_tag(%Tag{} = tag, attrs \\ %{}) do
    Tag.changeset(tag, attrs)
  end

  @doc """
  Returns the list of products_tags.

  ## Examples

      iex> list_products_tags()
      [%ProductTag{}, ...]

  """
  @spec list_products_tags() :: [ProductTag.t()]
  def list_products_tags do
    Repo.all(ProductTag)
  end

  @doc """
  Gets a single product_tag.

  Raises `Ecto.NoResultsError` if the Product tag does not exist.

  ## Examples

      iex> get_product_tag!(123)
      %ProductTag{}

      iex> get_product_tag!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_product_tag!(binary()) :: ProductTag.t() | no_return()
  def get_product_tag!(id), do: Repo.get!(ProductTag, id)

  @doc """
  Creates a product_tag.

  ## Examples

      iex> create_product_tag(%{field: value})
      {:ok, %ProductTag{}}

      iex> create_product_tag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_product_tag(map()) :: {:ok, ProductTag.t()} | {:error, Ecto.Changeset.t()}
  def create_product_tag(attrs \\ %{}) do
    %ProductTag{}
    |> ProductTag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product_tag.

  ## Examples

      iex> update_product_tag(product_tag, %{field: new_value})
      {:ok, %ProductTag{}}

      iex> update_product_tag(product_tag, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_product_tag(ProductTag.t(), map()) ::
          {:ok, ProductTag.t()} | {:error, Ecto.Changeset.t()}
  def update_product_tag(%ProductTag{} = product_tag, attrs) do
    product_tag
    |> ProductTag.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product_tag.

  ## Examples

      iex> delete_product_tag(product_tag)
      {:ok, %ProductTag{}}

      iex> delete_product_tag(product_tag)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_product_tag(ProductTag.t()) :: {:ok, ProductTag.t()} | {:error, Ecto.Changeset.t()}
  def delete_product_tag(%ProductTag{} = product_tag) do
    Repo.delete(product_tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product_tag changes.

  ## Examples

      iex> change_product_tag(product_tag)
      %Ecto.Changeset{data: %ProductTag{}}

  """
  @spec change_product_tag(ProductTag.t(), map()) :: Ecto.Changeset.t()
  def change_product_tag(%ProductTag{} = product_tag, attrs \\ %{}) do
    ProductTag.changeset(product_tag, attrs)
  end
end
