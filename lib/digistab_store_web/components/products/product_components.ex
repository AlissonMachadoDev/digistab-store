defmodule DigistabStoreWeb.ProductLive.ProductComponents do
  use Phoenix.Component

  # alias Phoenix.LiveView.JS
  # import DigistabStoreWeb.Gettext
  import DigistabStoreWeb.CoreComponents

  alias Phoenix.LiveView.JS

  use Gettext, backend: DigistabStoreWeb.Gettext
  ## Examples

  @doc """
  Renders a modal.

  ## Examples

      <.modal id="confirm-modal">
        Are you sure?
        <:confirm>OK</:confirm>
        <:cancel>Cancel</:cancel>
      </.modal>

  JS commands may be passed to the `:on_cancel` and `on_confirm` attributes
  for the caller to react to each button press, for example:

      <.modal id="confirm" on_confirm={JS.push("delete")} on_cancel={JS.navigate(~p"/posts")}>
        Are you sure you?
        <:confirm>OK</:confirm>
        <:cancel>Cancel</:cancel>
      </.modal>
  """
  attr :id, :string, required: true
  attr :class, :string, default: "max-w-3xl"
  attr :show, :boolean, default: false
  attr :on_cancel, JS, default: %JS{}
  attr :on_confirm, JS, default: %JS{}

  slot :inner_block, required: true
  slot :title
  slot :subtitle
  slot :confirm
  slot :cancel

  def product_modal(assigns) do
    ~H"""
    <div
      id={@id}
      phx-mounted={@show && show_modal(@id)}
      phx-remove={hide_modal(@id)}
      class="relative z-50 hidden"
    >
      <div id={"#{@id}-bg"} class="bg-zinc-50/90 fixed inset-0 transition-opacity" aria-hidden="true" />
      <div
        class="fixed inset-0 overflow-y-auto"
        aria-labelledby={"#{@id}-title"}
        aria-describedby={"#{@id}-description"}
        role="dialog"
        aria-modal="true"
        tabindex="0"
      >
        <div class="flex min-h-full items-center justify-center">
          <div class={"#{@class} w-full p-4 sm:p-6 lg:py-8"}>
            <.focus_wrap
              id={"#{@id}-container"}
              phx-mounted={@show && show_modal(@id)}
              phx-window-keydown={hide_modal(@on_cancel, @id)}
              phx-key="escape"
              phx-click-away={hide_modal(@on_cancel, @id)}
              class="shadow-zinc-700/10 ring-zinc-700/10 relative hidden rounded-lg bg-violet-100 p-4 shadow-lg ring-1 transition"
            >
              <div class="absolute top-4 right-4">
                <button
                  phx-click={hide_modal(@on_cancel, @id)}
                  type="button"
                  class="-m-3 flex-none p-3 opacity-20 hover:opacity-40"
                  aria-label={gettext("close")}
                >
                  <.icon name="hero-x-mark-solid" class="h-5 w-5" />
                </button>
              </div>
              <div id={"#{@id}-content"} class="text-center">
                <header :if={@title != []}>
                  <h1 id={"#{@id}-title"} class="text-lg font-semibold leading-8 text-zinc-800">
                    <%= render_slot(@title) %>
                  </h1>
                  <p
                    :if={@subtitle != []}
                    id={"#{@id}-description"}
                    class="text-sm leading-6 text-zinc-600"
                  >
                    <%= render_slot(@subtitle) %>
                  </p>
                </header>
                <%= render_slot(@inner_block) %>
                <div :if={@confirm != [] or @cancel != []} class="mb-4 ml-6 flex items-center gap-5">
                  <.button
                    :for={confirm <- @confirm}
                    id={"#{@id}-confirm"}
                    phx-click={@on_confirm}
                    phx-disable-with
                    class="bg-green-400 px-3 py-2"
                  >
                    <%= render_slot(confirm) %>
                  </.button>
                  <.link
                    :for={cancel <- @cancel}
                    phx-click={hide_modal(@on_cancel, @id)}
                    class="bg-gray-400 text-sm font-semibold leading-6  hover:text-violet-200"
                  >
                    <%= render_slot(cancel) %>
                  </.link>
                </div>
              </div>
            </.focus_wrap>
          </div>
        </div>
      </div>
    </div>
    """
  end

  attr :id, :any, default: nil
  attr :name, :any
  attr :label, :string, default: nil
  attr :value, :any, default: 0
  attr :description, :string, default: nil
  attr :currency, :string, default: "BRL"
  attr :item, :any
  attr :collection, :any

  attr :type, :string,
    default: "text",
    values:
      ~w(checkbox color date datetime-local email file hidden month number password
            range radio search select tel text textarea time url week wysiwyg select_with_description price custom_counter)

  attr :field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :errors, :list, default: []
  attr :checked, :boolean, doc: "the checked flag for checkbox inputs"
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
  attr :options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"
  attr :rest, :global, include: ~w(autocomplete cols disabled form max maxlength min minlength
                                pattern placeholder readonly required rows size step)
  slot :inner_block

  def product_input(%{type: "select_with_description"} = assigns) do
    assigns =
      assign(assigns, :value, if(is_nil(assigns.value), do: assigns.item, else: assigns.value))

    ~H"""
    <div phx-feedback-for={@name}>
      <.label for={@id} weight="font-medium"><%= @label %></.label>
      <select
        id={@id}
        name={@name}
        class="mt-1 block w-full rounded-md border border-gray-300 bg-white px-3 py-2 shadow-sm focus:border-violet-500 focus:outline-none focus:ring-zinc-500 sm:text-sm"
        multiple={@multiple}
        {@rest}
      >
        <option :if={@prompt} value=""><%= @prompt %></option>
        <%= Phoenix.HTML.Form.options_for_select(@options, @value) %>
      </select>
      <.error :for={msg <- @errors}><%= msg %></.error>
      <div class="my-2 text-sm">
        <%= Enum.find(@collection, fn item -> item.name == @value end)
        |> then(& &1.description) %>
      </div>
    </div>
    """
  end

  def product_input(%{type: "wysiwyg"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name} class="">
      <.label for={@id} weight="font-medium"><%= @label %></.label>
      <textarea id={@id || @name} name={@name} hidden={true} phx-hook="TrixEditor">

      <%= Phoenix.HTML.Form.normalize_value("textarea", @value) %>
      </textarea>
      <div
        id="richtext"
        phx-update="ignore"
        class={[
          "block w-full rounded-lg  border-violet-300 py-[7px] px-[11px]",
          "text-zinc-900 focus-within:outline-none focus-within:ring-4 sm:text-sm sm:leading-6 text-right",
          "phx-no-feedback:border-violet-300 phx-no-feedback:focus-within:border-violet-400 phx-no-feedback:focus-within:ring-zinc-800/5",
          "border border-violet-300 focus-within:border-violet-400 focus-within:ring-zinc-800/5",
          @errors != [] &&
            "border-rose-400 focus-within:border-rose-400 focus-within:ring-rose-400/10"
        ]}
      >
        <trix-toolbar id="trix-toolbar">
          <div class="trix-button-row">
            <span
              class="trix-button-group trix-button-group--text-tools justify-center"
              data-trix-button-group="text-tools"
            >
              <button
                type="button"
                class="trix-button trix-button--icon trix-button--icon-bold"
                data-trix-attribute="bold"
                data-trix-key="b"
                title="Bold"
                tabindex="-1"
              >
                Bold
              </button>
              <button
                type="button"
                class="trix-button trix-button--icon trix-button--icon-italic"
                data-trix-attribute="italic"
                data-trix-key="i"
                title="Italic"
                tabindex="-1"
              >
                Italic
              </button>
              <button
                type="button"
                class="trix-button trix-button--icon trix-button--icon-strike"
                data-trix-attribute="strike"
                title="Strikethrough"
                tabindex="-1"
              >
                Strikethrough
              </button>
            </span>
          </div>
        </trix-toolbar>
        <trix-editor
          input={@id}
          value={@value}
          class="w-full border-none px-2 text-left"
          toolbar="trix-toolbar"
        >
        </trix-editor>
      </div>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  def product_input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors =
      if Phoenix.Component.used_input?(field),
        do: field.errors,
        else: []

    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(errors, &translate_error(&1)))
    |> assign_new(:name, fn -> if assigns.multiple, do: field.name <> "[]", else: field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> product_input()
  end

  def product_input(%{type: "number"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name} class="content-between">
      <.label for={@id} weight="font-medium"><%= @label %></.label>
      <input
        type={@type}
        name={@name}
        id={@id || @name}
        value={Phoenix.HTML.Form.normalize_value(@type, @value)}
        class={[
          "block w-full rounded-lg  border-violet-300 py-[7px] px-[11px]",
          "text-zinc-900 focus:outline-none focus:ring-4 sm:text-sm sm:leading-6 text-right",
          "phx-no-feedback:border-violet-300 phx-no-feedback:focus:border-violet-400 phx-no-feedback:focus:ring-zinc-800/5",
          " border-violet-300 focus:border-violet-400 focus:ring-zinc-800/5",
          @errors != [] && "border-rose-400 focus:border-rose-400 focus:ring-rose-400/10"
        ]}
        {@rest}
      />
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  def product_input(%{type: "price"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name} class="content-between">
      <.label for={@id} weight="font-medium"><%= @label %></.label>
      <div class="flex flex-row items-center">
        <span class="px-4 py-2 rounded-md bg-green-200 mx-1">
          R$
        </span>
        <input
          type={@type}
          name={@name}
          id={@id || @name}
          value={Phoenix.HTML.Form.normalize_value("number", @value) |> set_initial_value(@currency)}
          class={[
            "block w-full rounded-lg  border-violet-300 py-[7px] px-[11px]",
            "text-zinc-900 focus:outline-none focus:ring-4 sm:text-sm sm:leading-6 text-right",
            "phx-no-feedback:border-violet-300 phx-no-feedback:focus:border-violet-400 phx-no-feedback:focus:ring-zinc-800/5",
            "border border-violet-300 focus:border-violet-400 focus:ring-zinc-800/5",
            @errors != [] && "border-rose-400 focus:border-rose-400 focus:ring-rose-400/10"
          ]}
          currency={@currency}
          autocomplete="off"
          phx-hook="IntegerPriceInput"
          {@rest}
        />
      </div>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  def product_input(%{type: "custom_counter"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name} class="content-between">
      <.label for={@id} weight="font-medium"><%= @label %></.label>
      <div class="relative bottom-0 flex w-full flex-row space-x-1 rounded-lg bg-transparent">
        <button
          type="button"
          data-action="decrement"
          class="rounded-md bg-violet-100 px-2 hover:bg-violet-800 hover:text-white active:bg-violet-500 disabled:bg-white disabled:text-gray-400"
        >
          <.icon name="hero-minus-circle-mini" class="h-4 w-4" />
        </button>
        <input
          type="number"
          phx-hook="CustomCounterInput"
          class={[
            "block w-full rounded-lg  border-violet-300 py-[7px] px-[11px]",
            "text-zinc-900 focus:outline-none focus:ring-4 sm:text-sm sm:leading-6 text-right",
            "phx-no-feedback:border-violet-300 phx-no-feedback:focus:border-violet-400 phx-no-feedback:focus:ring-zinc-800/5",
            "border border-violet-300 focus:border-violet-400 focus:ring-zinc-800/5",
            @errors != [] && "border-rose-400 focus:border-rose-400 focus:ring-rose-400/10"
          ]}
          id={@id || @name}
          name={@name}
          phx-update="ignore"
          value={Phoenix.HTML.Form.normalize_value("number", @value)}
          {@rest}
        />
        <button
          type="button"
          data-action="increment"
          class="rounded-md bg-violet-100 px-2 hover:bg-violet-800 hover:text-white active:bg-violet-500"
        >
          <.icon name="hero-plus-circle-mini" class="h-4 w-4" />
        </button>
        <style>
          input[type=number]::-webkit-inner-spin-button,
          input[type=number]::-webkit-outer-spin-button {
            -webkit-appearance: none;
            margin: 0;
          }

          .{@name} input:focus {
            outline: none !important;
          }

          .custom-number-input button:focus {
            outline: none !important;
          }
        </style>
      </div>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  defp set_initial_value(value, symbol) do
    if symbol == "$", do: set_dot_separator(value), else: set_comma_separator(value)
  end

  defp set_dot_separator(value) do
    if value == 0 do
      "0.00"
    else
      {first, second} =
        value
        |> Integer.to_string()
        |> String.split_at(-2)

      []
      "#{format_first_part(first)}.#{format_second_part(second)}"
    end
  end

  defp set_comma_separator(value) do
    if value in [0, nil] do
      "0,00"
    else
      {first, second} =
        value
        |> Integer.to_string()
        |> String.split_at(-2)

      []
      "#{format_first_part(first)},#{format_second_part(second)}"
    end
  end

  defp format_first_part(str) do
    if str == "" do
      "0"
    else
      str
    end
  end

  defp format_second_part(str) do
    if str == "" do
      "00"
    else
      if String.length(str) == 1 do
        "0#{str}"
      else
        str
      end
    end
  end
end
