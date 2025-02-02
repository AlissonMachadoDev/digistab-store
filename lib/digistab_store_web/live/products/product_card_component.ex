defmodule DigistabStoreWeb.Components.ProductCard do
  @moduledoc """
  Reusable product card component for index view.

  Example:
      <.product_card product={@product} />

  NOTES:
  - Always pass preloaded product
  - Uses skeleton loading for images

  #TODO: Verify about responsivity on mobile
  """
  use DigistabStoreWeb, :component
  import DigistabStoreWeb.CoreComponents
  import DigistabStoreWeb.Products.PriceComponent

  attr :product, :map, required: true

  def product_card(assigns) do
    ~H"""
    <div class="bg-white rounded-lg shadow-md overflow-hidden transition-transform hover:scale-[1.02]">
      <div class="relative">
        <div class="aspect-w-16 aspect-h-9">
          <%= if @product.photos && Enum.any?(@product.photos) do %>
            <div
              phx-click={JS.patch(~p"/products/#{@product.id}") |> JS.dispatch("scroll-top")}
              class="cursor-pointer"
            >
              <img
                src={List.first(@product.photos).url}
                alt={@product.name}
                class="w-full h-48 object-cover object-center rounded-lg transition-all duration-300 hover:scale-105"
                loading="lazy"
              />
            </div>
          <% else %>
            <div class="flex items-center justify-center w-full h-48 bg-gradient-to-br from-gray-100 to-gray-200 rounded-lg animate-pulse">
              <.icon name="hero-photo" class="w-12 h-12 text-gray-400" />
            </div>
          <% end %>
        </div>
      </div>
      <div class="p-4 space-y-3">
        <h3 class="text-lg text-gray-800 font-medium line-clamp-1">
          <%= @product.name %>
        </h3>

        <div class="space-y-2">
          <.product_price price={@product.price} promotional_price={@product.promotional_price} />

          <%= if @product.stock > 0 do %>
            <button
              type="button"
              phx-click="add_to_cart"
              phx-value-id={@product.id}
              class="w-full py-2 px-4 bg-purple-600 hover:bg-purple-700 text-white font-semibold rounded-lg transition-colors"
            >
              ADD TO CART
            </button>
          <% else %>
            <div class="w-full py-2 px-4 bg-gray-400 text-white font-semibold rounded-lg text-center cursor-not-allowed">
              OUT OF STOCK
            </div>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
