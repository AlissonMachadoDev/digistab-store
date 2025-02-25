defmodule DigistabStoreWeb.Layouts.LayoutComponents do
  use Phoenix.Component
  use DigistabStoreWeb, :verified_routes

  # alias Phoenix.LiveView.JS
  # import DigistabStoreWeb.Gettext
  import DigistabStoreWeb.CoreComponents

  @doc """
  renders the navbar to show all the categories
  """

  attr :categories, :list, required: true

  def navbar(assigns) do
    ~H"""
    <header
      class="fixed top-0 left-10 right-10 z-20 bg-white"
      x-id="['navbar']"
      x-data="{
    categories: false
    }"
    >
      <div class="flex md:flex-row flex-col md:h-14 items-center md:justify-between md:items-end border-b border-b-gray-300 shadow-md">
        <.link patch={~p"/products"} class="flex items-center gap-4 mb-2">
          <img src="/images/plain_logo.svg" />
        </.link>

        <div class="flex flex-row border-gray-200 space-x-2">
          <button class="flex flex-row px-4 py-1 space-x-1 text-violet-500 hover:bg-violet-500 hover:text-white  cursor-not-allowed">
            <p>
              10
            </p>
            <p class="font-semibold">
              <.icon name="hero-shopping-cart" />
            </p>
          </button>
          <button
            x-ref="button_categories"
            @click="categories = !categories"
            @keydown.escape.prevent.stop="categories = false"
            x-bind:aria-expanded="categories"
            x-bind:aria-controls="$id('navbar')"
            class="flex flex-row px-4 py-1 space-x-1 text-violet-500 hover:bg-violet-500 hover:text-white hover:cursor-pointer "
          >
            <p>
              Categories
            </p>
            <p class="text-gray-800">
              <%= icon(%{name: "hero-chevron-down"}) %>
            </p>
          </button>
          <button class="flex flex-row px-4 pt-1 pb-2 space-x-1 text-violet-500 hover:bg-violet-500 hover:text-white  cursor-not-allowed">
            <p>
              My account
            </p>
            <p class="text-gray-800 text-sm">
              <%= icon(%{name: "hero-chevron-down", class: "text-sm"}) %>
            </p>
          </button>
        </div>
      </div>
      <div
        x-bind:id="$id('navbar')"
        x-show="categories"
        x-transition.origin.top.left
        @click.outside="categories = false"
        class="flex flex-col md:w-fit md:flex-none md:grid md:grid-cols-2 md:gap-x-12 md:gap-y-2 mx-2 px-4 py-2 bg-violet-300 rounded-b-md shadow-md md:absolute md:right-16 opacity-95"
      >
        <a
          :for={category <- @categories}
          href={~p"/products/categories/#{category.id}"}
          class="bg-violet-100 hover:bg-gray-200 md:w-48 px-2 py-1 md:text-left text-center rounded-md border-b"
        >
          <%= category.name %>
        </a>
      </div>
    </header>
    """
  end

  def footer(assigns) do
    ~H"""
    <footer class="flex w-full bottom-0 z-10">
      <div class="flex flex-col w-full px-10 bg-gradient-to-t from-violet-400 to-white">
        <div class="flex w-full md:flex-row md:justify-between flex-col-reverse">
          <div class=" flex flex-row mb-8 md:ml-8">
            <div class="flex flex-col items-center justify-center w-96">
              <div class="flex w-72 gap-4 mb-2"><img src="/images/logo.svg" /></div>
              <p class="text-justify italic">
                Digistab Store is a fictional brand created by Alisson Machado just to illustrate design and development skills, so there is no related brand as far as I know.
              </p>
            </div>
          </div>
          <div class="flex flex-col md:flex-row md:w-1/2 justify-around">
            <div class="flex flex-col w-fit">
              <h2 class="font-semibold text-center mb-2">Technologies</h2>
              <div class="grid grid-cols-2 gap-x-4 gap-y-1 text-center">
                <p>Elixir</p>
                <p>Phoenix</p>
                <p>Liveview</p>
                <p>Tailwind</p>
                <p>AlpineJS</p>
                <p>PostgreSQL</p>
              </div>
            </div>
          </div>
        </div>
        <hr class="mb-8 border-2 border-violet-700" />
      </div>
    </footer>
    """
  end
end
