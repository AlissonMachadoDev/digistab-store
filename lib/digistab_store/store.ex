defmodule DigistabStore.Store do
  @moduledoc """
  The Store context.
  """

  import Ecto.Query, warn: false
  alias DigistabStore.Repo

  alias DigistabStore.Store.Product

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products do
    Repo.all(Product)
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
  def get_product!(id), do: Repo.get!(Product, id)

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
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
  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{data: %Product{}}

  """
  def change_product(%Product{} = product, attrs \\ %{}) do
    product
    |> Repo.preload([:status, :category])
    |> Product.changeset(attrs)
  end

  alias DigistabStore.Store.Status

  @doc """
  Returns the list of status_collection.

  ## Examples

      iex> list_status_collection()
      [%Status{}, ...]

  """
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
  def get_status!(id), do: Repo.get!(Status, id)

  @doc """
  Creates a status.

  ## Examples

      iex> create_status(%{field: value})
      {:ok, %Status{}}

      iex> create_status(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
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
  def delete_status(%Status{} = status) do
    Repo.delete(status)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking status changes.

  ## Examples

      iex> change_status(status)
      %Ecto.Changeset{data: %Status{}}

  """
  def change_status(%Status{} = status, attrs \\ %{}) do
    Status.changeset(status, attrs)
  end

  alias DigistabStore.Store.Category

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
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
  def get_category!(id), do: Repo.get!(Category, id)

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
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
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{data: %Category{}}

  """
  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end

  alias DigistabStore.Store.TagType

  @doc """
  Returns the list of tag_types.

  ## Examples

      iex> list_tag_types()
      [%TagType{}, ...]

  """
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
  def get_tag_type!(id), do: Repo.get!(TagType, id)

  @doc """
  Creates a tag_type.

  ## Examples

      iex> create_tag_type(%{field: value})
      {:ok, %TagType{}}

      iex> create_tag_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
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
  def delete_tag_type(%TagType{} = tag_type) do
    Repo.delete(tag_type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tag_type changes.

  ## Examples

      iex> change_tag_type(tag_type)
      %Ecto.Changeset{data: %TagType{}}

  """
  def change_tag_type(%TagType{} = tag_type, attrs \\ %{}) do
    TagType.changeset(tag_type, attrs)
  end

  alias DigistabStore.Store.Tag

  @doc """
  Returns the list of tags.

  ## Examples

      iex> list_tags()
      [%Tag{}, ...]

  """
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
  def get_tag!(id), do: Repo.get!(Tag, id)

  @doc """
  Creates a tag.

  ## Examples

      iex> create_tag(%{field: value})
      {:ok, %Tag{}}

      iex> create_tag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
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
  def delete_tag(%Tag{} = tag) do
    Repo.delete(tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tag changes.

  ## Examples

      iex> change_tag(tag)
      %Ecto.Changeset{data: %Tag{}}

  """
  def change_tag(%Tag{} = tag, attrs \\ %{}) do
    Tag.changeset(tag, attrs)
  end

  alias DigistabStore.Store.ProductTag

  @doc """
  Returns the list of products_tags.

  ## Examples

      iex> list_products_tags()
      [%ProductTag{}, ...]

  """
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
  def get_product_tag!(id), do: Repo.get!(ProductTag, id)

  @doc """
  Creates a product_tag.

  ## Examples

      iex> create_product_tag(%{field: value})
      {:ok, %ProductTag{}}

      iex> create_product_tag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
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
  def delete_product_tag(%ProductTag{} = product_tag) do
    Repo.delete(product_tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product_tag changes.

  ## Examples

      iex> change_product_tag(product_tag)
      %Ecto.Changeset{data: %ProductTag{}}

  """
  def change_product_tag(%ProductTag{} = product_tag, attrs \\ %{}) do
    ProductTag.changeset(product_tag, attrs)
  end

  alias DigistabStore.Store.ProductCategory

  @doc """
  Returns the list of products_categories.

  ## Examples

      iex> list_products_categories()
      [%ProductCategory{}, ...]

  """
  def list_products_categories do
    Repo.all(ProductCategory)
  end

  @doc """
  Gets a single product_category.

  Raises `Ecto.NoResultsError` if the Product category does not exist.

  ## Examples

      iex> get_product_category!(123)
      %ProductCategory{}

      iex> get_product_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product_category!(id), do: Repo.get!(ProductCategory, id)

  @doc """
  Creates a product_category.

  ## Examples

      iex> create_product_category(%{field: value})
      {:ok, %ProductCategory{}}

      iex> create_product_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product_category(attrs \\ %{}) do
    %ProductCategory{}
    |> ProductCategory.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product_category.

  ## Examples

      iex> update_product_category(product_category, %{field: new_value})
      {:ok, %ProductCategory{}}

      iex> update_product_category(product_category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product_category(%ProductCategory{} = product_category, attrs) do
    product_category
    |> ProductCategory.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product_category.

  ## Examples

      iex> delete_product_category(product_category)
      {:ok, %ProductCategory{}}

      iex> delete_product_category(product_category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product_category(%ProductCategory{} = product_category) do
    Repo.delete(product_category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product_category changes.

  ## Examples

      iex> change_product_category(product_category)
      %Ecto.Changeset{data: %ProductCategory{}}

  """
  def change_product_category(%ProductCategory{} = product_category, attrs \\ %{}) do
    ProductCategory.changeset(product_category, attrs)
  end
end
