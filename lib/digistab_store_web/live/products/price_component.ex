defmodule DigistabStoreWeb.Products.PriceComponent do
  @moduledoc """
  Displays product prices with promotional pricing support.
  Handles currency formatting and applies different styles for promotional prices.

  Basic example:
    <.product_price price={1000} promotional_price={800} />

  Will render:
    R$10.00
    R$8.00 (highlighted promotional price)

  #TODO: Verify the region and currency settings for the store
  """
  use Phoenix.Component

  attr :price, :integer, required: true
  attr :promotional_price, :integer, required: true

  def product_price(assigns) do
    ~H"""
    <div class="mt-4 flex justify-end ">
      <span :if={@promotional_price != 0} class="text-gray-400 line-through text-lg">
        R$ <%= format_price(@price) %>
      </span>
      <span class="ml-2 text-3xl font-bold text-violet-600">
        R$ <%= get_price(@price, @promotional_price) |> format_price() %>
      </span>
    </div>
    """
  end

  # Get the price to display based on the promotional price.
  defp get_price(price, promo_price) do
    if promo_price != 0 do
      promo_price
    else
      price
    end
  end

  # Format the price to display in the view.
  defp format_price(price) do
    price
    |> Decimal.new()
    |> Decimal.div(100)
    |> Decimal.to_string(:normal)
  end
end
