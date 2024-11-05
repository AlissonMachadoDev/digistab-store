defmodule DigistabStoreWeb.Products.PriceComponent do
  use Phoenix.Component


  attr :price, :integer, required: true
  attr :promotional_price, :integer, required: true
  def product_price(assigns) do
    ~H"""
        <div class="mt-4 flex justify-end ">
          <span class="text-gray-400 line-through text-lg" :if={@promotional_price != 0}>
            R$ <%= format_price(@price) %>
          </span>
          <span class="ml-2 text-3xl font-bold text-violet-600">
            R$ <%= get_price(@price, @promotional_price) |> format_price() %>
          </span>
        </div>
    """
  end

  defp get_price(price, promo_price) do
    if promo_price != 0 do
      promo_price
    else
      price
    end
  end

  defp format_price(price) do
    price
    |> Decimal.new()
    |> Decimal.div(100)
    |> Decimal.to_string(:normal)
  end
end
