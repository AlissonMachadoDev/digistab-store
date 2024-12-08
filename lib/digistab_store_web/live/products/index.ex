defmodule DigistabStoreWeb.ProductLive.Index do
  @moduledoc """
  LiveView for product listing and management.

  This module handles:
  - Display of product grid
  - Featured products carousel
  - Product search
  - Product creation/editing through modal forms
  - Real-time updates
  """
  use DigistabStoreWeb, :live_view

  alias DigistabStore.Store
  alias DigistabStore.Store.Product

  import DigistabStoreWeb.ProductLive.ProductComponents
  import DigistabStoreWeb.ProductCarousel
  import DigistabStoreWeb.Components.ProductCard

  @impl true
  def mount(_params, _session, socket) do
    {:ok, default_assigns(socket)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :category, %{"id" => id}) do
    send(self(), {:handle_category, id})
    category = Store.get_category!(id)

    socket
    |> assign(
      page_title: "#{category.name}",
      default_section_name: "Products listed on '#{category.name}'",
      featured_products: [],
      loading: true,
      current_action: :category
    )
    |> stream(:products, [], reset: true)
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Product")
    |> assign(:current_action, :edit)
    |> assign(:product, Store.get_product!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Product")
    |> assign(:current_action, :new)
    |> assign(:product, %Product{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:product, nil)
    |> default_assigns()
  end

  @impl true
  def handle_info({DigistabStoreWeb.ProductLive.FormComponent, {:saved, product}}, socket) do
    socket =
      socket
      |> stream_insert(:products, product)
      |> reload_featured_products(product)

    {:noreply, socket}
  end

  def handle_info({:run_search, query}, socket) do
    socket =
      socket
      |> stream(:products, Store.search_products(query), reset: true)
      |> assign(
        loading: false,
        default_section_name: "Found products by '#{query}'"
      )

    {:noreply, socket}
  end

  def handle_info({:handle_category, id}, socket) do
    :timer.sleep(1000)

    socket =
      socket
      |> assign(loading: false)
      |> stream(:products, Store.list_products_by_category(id), reset: true)

    {:noreply, socket}
  end

  @impl true
  def handle_event("search", %{"search" => %{"query" => ""}}, socket) do
    socket =
      socket
      |> assign(
        featured_products: Store.list_featured_products(),
        default_section_name: "Other products",
        current_action: :index
      )
      |> stream(:products, Store.list_products(), reset: true)

    {:noreply, socket}
  end

  def handle_event("search", %{"search" => %{"query" => query}}, socket) do
    send(self(), {:run_search, query})

    socket =
      socket
      |> assign(featured_products: [], loading: true, current_action: :search)
      |> stream(:products, [], reset: true)

    {:noreply, socket}
  end

  def handle_event("add_to_cart", %{"id" => _id}, socket) do
    # To implement
    {:noreply, socket}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    product = Store.get_product!(id)
    {:ok, _} = Store.delete_product(product)

    socket =
      socket
      |> stream_delete(:products, product)
      |> reload_featured_products(product)

    {:noreply, socket}
  end

  @doc """
    Selectively reloads featured products when a product's featured status changes.
  Only triggers reload if the product is or was featured.
  """
  def reload_featured_products(socket, %{featured?: false}), do: socket

  def reload_featured_products(socket, _) do
    socket
    |> assign(featured_products: Store.list_featured_products())
  end

  defp default_assigns(socket) do
    featured_products = Store.list_featured_products()

    products = Store.list_products()

    assign(socket,
      query: "",
      cart_count: 10,
      default_section_name: "Other products",
      page_title: "Listing Products",
      loading: false,
      current_action: :index
    )
    |> assign(:featured_products, featured_products)
    |> stream(:products, products)
  end
end
