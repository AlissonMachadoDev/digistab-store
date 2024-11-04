defmodule DigistabStoreWeb.ProductCarousel do
  use Phoenix.Component
  import DigistabStoreWeb.CoreComponents

  def featured_carousel(assigns) do
    ~H"""
    <div
      x-data="{
        currentIndex: 0,
        items: [],
        init() {
          this.items = [...this.$refs.carousel.children];
          this.showSlide(0);
          setInterval(() => this.next(), 10000); // Auto-advance every 10 seconds
        },
        next() {
          this.currentIndex = (this.currentIndex + 1) % (this.items.length - 1);
          this.showSlide(this.currentIndex);
        },
        prev() {
          this.currentIndex = (this.currentIndex - 1 + (this.items.length - 1)) % (this.items.length - 1);
          this.showSlide(this.currentIndex);
        },
        showSlide(index) {
        this.currentIndex = index;
          this.items.forEach((el, i) => {
            if (i === index) {
              el.classList.remove('translate-x-full', '-translate-x-full');
              el.classList.add('translate-x-0');
            } else if (i < index) {
              el.classList.remove('translate-x-0', 'translate-x-full');
              el.classList.add('-translate-x-full');
            } else {
              el.classList.remove('translate-x-0', '-translate-x-full');
              el.classList.add('translate-x-full');
            }
          });
        }
      }"
      class="relative w-full overflow-hidden"
    >
      <div class="absolute inset-y-0 left-0 z-10 flex items-center">
        <button
          @click="prev()"
          class="p-2 m-2 text-gray-600 hover:text-purple-600 bg-white/80 rounded-full shadow-lg"
          aria-label="Previous slide"
        >
          <.icon name="hero-chevron-left-solid" class="w-6 h-6" />
        </button>
      </div>

      <div class="absolute inset-y-0 right-0 z-10 flex items-center">
        <button
          @click="next()"
          class="p-2 m-2 text-gray-600 hover:text-purple-600 bg-white/80 rounded-full shadow-lg"
          aria-label="Next slide"
        >
          <.icon name="hero-chevron-right-solid" class="w-6 h-6" />
        </button>
      </div>

      <div x-ref="carousel" class="relative h-96" id="products_carousel">
        <div
          :for={{product, index} <- Enum.with_index(@featured_products)}
          class={[
            "absolute top-0 left-0 w-full h-full transition-transform duration-500 ease-in-out transform",
            if(index == 0, do: "translate-x-0", else: "translate-x-full")
          ]}
        >
          <div class="grid md:grid-cols-2 gap-6 px-4">
            <div class="bg-white rounded-lg shadow-md p-4">
              <div class="aspect-w-16 aspect-h-9 mb-4">
                <%= if product.photos && Enum.any?(product.photos) do %>
                  <img
                    src={List.first(product.photos).url}
                    alt={product.name}
                    class="w-full h-48 object-cover object-center rounded-lg transition-all duration-300 hover:scale-105"
                    loading="lazy"
                  />
                <% else %>
                  <div class="flex items-center justify-center w-full h-48 bg-gradient-to-br from-gray-100 to-gray-200 rounded-lg animate-pulse">
                    <.icon name="hero-photo" class="w-12 h-12 text-gray-400" />
                  </div>
                <% end %>
              </div>
              <h3 class="font-medium text-gray-900 mb-2"><%= product.name %></h3>
              <div class="flex items-center justify-between">
                <div>
                  <span class="text-sm text-gray-500 line-through">
                    R$ <%= format_price(product.price) %>
                  </span>
                  <span class="text-lg font-bold text-purple-600 ml-2">
                    R$ <%= format_price(product.promotional_price) %>
                  </span>
                </div>
                <button
                  phx-click="add_to_cart"
                  phx-value-id={product.id}
                  class="bg-purple-600 text-white px-4 py-2 rounded-lg hover:bg-purple-700"
                >
                  ADICIONAR
                </button>
              </div>
            </div>
            <%= if index + 1 < length(@featured_products) do %>
              <div class="bg-white rounded-lg shadow-md p-4">
                <div class="aspect-w-16 aspect-h-9 mb-4">
                  <%= if Enum.at(@featured_products, index + 1).photos && Enum.any?(Enum.at(@featured_products, index + 1).photos) do %>
                    <img
                      src={List.first(Enum.at(@featured_products, index + 1).photos).url}
                      alt={Enum.at(@featured_products, index + 1).name}
                      class="w-full h-48 object-cover object-center rounded-lg transition-all duration-300 hover:scale-105"
                      loading="lazy"
                    />
                  <% else %>
                    <div class="flex items-center justify-center w-full h-48 bg-gradient-to-br from-gray-100 to-gray-200 rounded-lg animate-pulse">
                      <.icon name="hero-photo" class="w-12 h-12 text-gray-400" />
                    </div>
                  <% end %>
                </div>
                <h3 class="font-medium text-gray-900 mb-2">
                  <%= Enum.at(@featured_products, index + 1).name %>
                </h3>
                <div class="flex items-center justify-between">
                  <div>
                    <span class="text-sm text-gray-500 line-through">
                      R$ <%= Enum.at(@featured_products, index + 1).price |> format_price() %>
                    </span>
                    <span class="text-lg font-bold text-purple-600 ml-2">
                      R$ <%= Enum.at(@featured_products, index + 1).promotional_price
                      |> format_price() %>
                    </span>
                  </div>
                  <button
                    phx-click="add_to_cart"
                    phx-value-id={Enum.at(@featured_products, index + 1).id}
                    class="bg-purple-600 text-white px-4 py-2 rounded-lg hover:bg-purple-700"
                  >
                    ADICIONAR
                  </button>
                </div>
              </div>
            <% end %>
          </div>
        </div>
      </div>
      <!-- Indicadores de slides -->
      <div class="absolute bottom-4 left-0 right-0 flex justify-center gap-2">
        <%= for i <- 0..(length(@featured_products) - 2) do %>
          <button
            @click={"showSlide(#{i})"}
            x-bind:class={"currentIndex === #{i} ?
        'w-3 h-3 rounded-full transition-colors duration-300 bg-purple-600 scale-110 ring-2 ring-purple-400' :
        'w-3 h-3 rounded-full transition-colors duration-300 bg-purple-400 hover:bg-purple-500'"}
            aria-label={"Go to slide #{i + 1}"}
            aria-current={i == 0 && "true"}
          >
          </button>
        <% end %>
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
