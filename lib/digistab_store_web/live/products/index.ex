defmodule DigistabStoreWeb.ProductLive.Index do
  use DigistabStoreWeb, :live_view

  alias DigistabStore.Store
  alias DigistabStore.Store.Product

  import DigistabStoreWeb.ProductLive.ProductComponents
  import DigistabStoreWeb.ProductCarousel
  import DigistabStoreWeb.Components.ProductCard

  @impl true
  def mount(_params, _session, socket) do
    featured_products = Store.list_featured_products()

    products = Store.list_products()

    {:ok,
     assign(socket,
       query: "",
       cart_count: 10
     )
     |> assign(:featured_products, featured_products)
     |> stream(:products, products)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Product")
    |> assign(:product, Store.get_product!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Product")
    |> assign(:product, %Product{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Products")
    |> assign(:product, nil)
  end

  @impl true
  def handle_info({DigistabStoreWeb.ProductLive.FormComponent, {:saved, product}}, socket) do
    socket =
      socket
      |> stream_insert(:products, product)
      |> reload_featured_products(product)

    {:noreply, socket}
  end

  @impl true
  def handle_event("search", %{"search" => %{"query" => _query}}, socket) do
    # To implement
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

  def reload_featured_products(socket, %{featured?: false}), do: socket

  def reload_featured_products(socket, _) do
    socket
    |> assign(featured_products: Store.list_featured_products())
  end
end
