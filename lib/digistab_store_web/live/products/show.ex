defmodule DigistabStoreWeb.ProductLive.Show do
  @moduledoc """
  ProductLive.Show

  This module handles displaying a product's details in a live view.
  It provides a dynamic interface for showing product information and updates automatically on changes.

  Key Responsibilities:
  - Loads product data when the component is mounted.
  - Supports real-time updates to the product view.

  Note: Designed for integration with LiveView, ensuring data is always current.
  """
  use DigistabStoreWeb, :live_view

  import DigistabStoreWeb.Products.PriceComponent

  alias DigistabStore.Store

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:product, Store.get_product!(id))}
  end

  defp page_title(:show), do: "Show Product"
  defp page_title(:edit), do: "Edit Product"

  def format_price(price) when is_integer(price) do
    Money.new(price, :BRL)
  end

  def stock_color(stock) when stock > 10, do: "text-green-600 font-medium"
  def stock_color(stock) when stock > 0, do: "text-yellow-600 font-medium"
  def stock_color(_stock), do: "text-red-600 font-medium"
end
