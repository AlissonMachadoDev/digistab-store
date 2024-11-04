defmodule DigistabStoreWeb.Components.ProductCard do
  use Phoenix.Component
  import DigistabStoreWeb.CoreComponents

  attr :product, :map, required: true

  def product_card(assigns) do
    ~H"""
    <div class="bg-white rounded-lg shadow-md overflow-hidden transition-transform hover:scale-[1.02]">
      <div class="relative">
        <div class="aspect-w-16 aspect-h-9">
          <%= if @product.photos && Enum.any?(@product.photos) do %>
            <img
              src={List.first(@product.photos).url}
              alt={@product.name}
              class="w-full h-48 object-cover object-center rounded-lg transition-all duration-300 hover:scale-105"
              loading="lazy"
            />
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
          <div class="flex items-baseline space-x-2">
            <span class="text-gray-400 line-through text-sm">
              R$ <%= format_price(@product.price) %>
            </span>
            <span class="text-purple-600 text-2xl font-bold">
              R$ <%= format_price(@product.promotional_price) %>
            </span>
          </div>

          <%= if @product.stock > 0 do %>
            <button
              type="button"
              phx-click="add_to_cart"
              phx-value-id={@product.id}
              class="w-full py-2 px-4 bg-purple-600 hover:bg-purple-700 text-white font-semibold rounded-lg transition-colors"
            >
              ADICIONAR
            </button>
          <% else %>
            <div class="w-full py-2 px-4 bg-gray-400 text-white font-semibold rounded-lg text-center cursor-not-allowed">
              INDISPONÍVEL
            </div>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  defp format_price(price) do
    price
    |> Decimal.new()
    |> Decimal.div(100)
    |> Decimal.to_string(:normal)
  end
end
