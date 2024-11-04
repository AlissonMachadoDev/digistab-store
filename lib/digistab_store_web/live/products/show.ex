defmodule DigistabStoreWeb.ProductLive.Show do
  use DigistabStoreWeb, :live_view

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

  def can_edit?(_current_user) do
    # TODO: Implement proper authorization
    true
  end
end
