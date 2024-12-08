defmodule DigistabStoreWeb.ProductLive.FormComponent do
  @moduledoc """
  LiveComponent for product form handling.

  Provides a rich interface for product creation and editing with:
  - Real-time validation
  - Image upload with S3 integration
  - Rich text description editor
  - Tag management
  - Price formatting
  - Stock control


  """
  use DigistabStoreWeb, :live_component

  import DigistabStoreWeb.ProductLive.ProductComponents

  alias DigistabStore.Store

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <!--:subtitle>Use this form to manage product records in your database.</!--:subtitle-->
      </.header>

      <.simple_form
        multipart
        for={@form}
        id="product-form"
        phx-change="validate"
        phx-submit="save"
        phx-target={@myself}
      >
        <div class="flex flex-col md:mx-4 md:flex-row rounded-md">
          <div class="mb-4 md:mr-4 md:mb-0 md:w-3/5">
            <div class="mb-4 space-y-4 shadow-inner-md bg-white p-4 text-left">
              <.input
                field={@form[:name]}
                type="text"
                label="Product name"
                placeholder="Product name"
              />
              <.product_input
                field={@form[:description]}
                type="wysiwyg"
                label="Description"
                name="put-description"
                value={@product.description}
              />
            </div>
            <div class="mb-4 h-fit rounded-md bg-white p-4">
              <.live_upload :if={@action == :new} uploads={@uploads.photos} myself={@myself} />
              <div :if={@action != :new}>
                <div class="flex flex-col">
                  <div class="flex flex-col justify-around md:flex-row h-36 w-full rounded-md border-2 border-dashed border-gray-300 p-4 text-center">
                    <div class="text-bold text-xl text-violet-700">
                      Photo update will be comming soon
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="grid grid-rows-3 gap-4 rounded-md bg-white p-4 sm:grid-cols-3 sm:grid-rows-none bottom-20">
              <.product_input
                field={@form[:price]}
                type="price"
                label="Price"
                name="put-price"
                value={@product.price}
              />
              <.product_input
                field={@form[:promotional_price]}
                type="price"
                label="Promotional price"
                name="put-promo-price"
                value={@product.promotional_price}
              />
              <.product_input
                field={@form[:stock]}
                type="custom_counter"
                label="Stock"
                name="put-stock"
                value={@product.stock}
              />
            </div>
          </div>
          <div class="flex flex-col justify-between md:h-128 md:w-2/5">
            <div class="flex flex-col justify-between sm:flex-row sm:space-x-4 md:flex-col md:space-x-0">
              <div class="mb-4 w-full rounded-md bg-white p-4 sm:w-1/2 md:w-full">
                <.product_input
                  field={@form[:status_name]}
                  type="select_with_description"
                  label="Status"
                  collection={@status_collection}
                  name="select-status"
                  options={@status}
                  value={select_item(@status_collection, @product.status_id) |> Map.get(:name)}
                  item={select_item(@status_collection, @product.status_id) |> Map.get(:name)}
                />
              </div>
              <div class="mb-4 w-full rounded-md bg-white p-4 sm:w-1/2 md:w-full">
                <.product_input
                  field={@form[:category_name]}
                  type="select_with_description"
                  label="Categories"
                  name="select-category"
                  collection={@categories_collection}
                  options={@categories}
                  value={select_item(@categories_collection, @product.category_id) |> Map.get(:name)}
                  item={select_item(@categories_collection, @product.category_id) |> Map.get(:name)}
                />
              </div>
            </div>
            <div class="h-full rounded-md bg-white p-4">
              <.tag_selector
                tags={@tags}
                fetched_tags={@fetched_tags}
                selected_tags={@selected_tags}
                tag_name={@tag_name}
                myself={@myself}
              />
            </div>
          </div>
        </div>
        <:actions>
          <.button
            phx-click={hide_modal(@on_cancel, @id)}
            class="w-24 bg-red-400 text-sm font-semibold leading-6 text-zinc-900 hover:bg-red-700 hover:text-zinc-300"
            type="button"
          >
            Cancel
          </.button>
          <.button
            class="w-24 bg-green-400 text-sm font-semibold leading-6 text-zinc-900 hover:bg-green-700 hover:text-zinc-300"
            phx-disable-with="Saving..."
            type="submit"
          >
            Save
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def tag_selector(assigns) do
    ~H"""
    <div>
      <div class="text-left">
        <.input
          name="search_tag"
          type="text"
          label="Buscar tag"
          placeholder="Digite a tag a ser buscada"
          value={@tag_name}
          autocomplete="off"
        />
      </div>
      <div :if={@fetched_tags != []} class="flex flex-col border-t border-b py-2 text-left">
        <p>Fetched tags</p>
        <div class="flex w-full flex-row flex-wrap justify-between">
          <div
            :for={tag <- @fetched_tags}
            title={"Type: #{tag.tag_type.name}"}
            class="mx-1 my-1 w-fit cursor-pointer rounded-md border bg-violet-500 px-2 py-1 text-sm text-white"
            phx-click="select-tag"
            phx-value-id={tag.id}
            phx-target={@myself}
          >
            <%= tag.name %>
          </div>
        </div>
      </div>
      <div :if={@selected_tags != []} class="flex flex-col border-t border-b py-2 text-left">
        <p>Selected tags</p>
        <div class="flex w-full flex-row flex-wrap justify-between">
          <div
            :for={tag <- @selected_tags}
            class="mx-1 my-1 w-fit cursor-pointer rounded-md border bg-violet-300 px-2 py-1 text-sm"
            phx-click="remove-tag"
            phx-value-id={tag.id}
            phx-target={@myself}
          >
            <%= tag.name %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def live_upload(assigns) do
    ~H"""
    <div class="flex flex-col">
      <div class="flex flex-col justify-around md:flex-row">
        <div
          :if={has_uploads?(@uploads.entries)}
          class={"flex h-fit flex-col rounded-md bg-violet-100 shadow-inner " <> if (length(@uploads.entries) < 5), do: " w-full md:w-2/3", else: " w-full"}
        >
          <div class={"flex h-fit flex-row " <> if (has_uploads?(@uploads.entries)), do: " overflow-auto scrollbar-thin scrollbar-thumb-slate-300 scrollbar-track-slate-100 scrollbar-rounded-md", else: ""}>
            <.image_live_preview :for={entry <- @uploads.entries} entry={entry} myself={@myself} />
          </div>
        </div>

        <div
          :if={length(@uploads.entries) < 5}
          class={upload_field(has_uploads?(@uploads.entries))}
          phx-drop-target={@uploads.ref}
          onClick={"document.getElementById('#{@uploads.ref}').click();"}
        >
          <div class="m-auto">
            <.icon
              name="hero-arrow-up-tray"
              class={"mx-auto h-12 w-12 text-gray-700 " <> if (!has_uploads?(@uploads.entries)), do: "block", else: "hidden md:block"}
            />
            <div :if={!has_uploads?(@uploads.entries)} class="font-medium text-black md:hidden">
              <p>
                <label class="text-violet-600" for="photos">browse the files</label>&nbsp;from device
              </p>
            </div>
            <div :if={!has_uploads?(@uploads.entries)} class="hidden font-medium text-black md:block">
              <p>
                Drag & drop the product photos here<br />or&nbsp;<a class="text-violet-700">browse the files</a>&nbsp;from device
              </p>
            </div>
            <div :if={has_uploads?(@uploads.entries)} class="font-medium text-black md:block">
              <a class="text-center text-violet-700">Add more...</a>&nbsp;
            </div>
            <a class="text-center text-red-700 text-sm">(max files: 5)</a>&nbsp;
          </div>
        </div>
        <.live_file_input upload={@uploads} class="hidden" />
      </div>
      <div class="rounded-lg bg-red-200 mt-2">
        <div :for={entry <- @uploads.entries}>
          <div :for={err <- upload_errors(@uploads, entry)} class="mt-1 p-1" role="alert">
            <p><%= entry.client_name %> - <%= error_to_string(err) %></p>
          </div>
        </div>
        <div :for={err <- upload_errors(@uploads)} class="mt-1 p-1" role="alert">
          <%= error_to_string(err) %>
        </div>
      </div>
    </div>
    """
  end

  def image_live_preview(assigns) do
    ~H"""
    <div class="mx-0-5 relative h-fit">
      <div class="w-36" title={@entry.client_name}>
        <div
          class="absolute top-0 right-0 flex h-8 w-8 cursor-pointer rounded-full border bg-red-400"
          phx-click="cancel-upload"
          phx-value-ref={@entry.ref}
          phx-target={@myself}
        >
          <.icon name="hero-x-circle" class="m-auto h-6 w-6 text-white" />
        </div>
        <div class="z-0 m-2 h-36 w-32 rounded-md border-2 border-dashed border-gray-300 bg-white p-4 text-center">
          <div class="flex h-full p-1">
            <.live_img_preview entry={@entry} class="w-full object-scale-down" />
          </div>
        </div>
      </div>
      <label class="mt-auto" title={@entry.client_name}>
        <%= truncate_filename(@entry.client_name) %>
      </label>
      <div class="progress m-2 h-2 w-32 rounded-lg border bg-white shadow-lg">
        <div
          class="progress-bar bg-by-theme-four bg-violet-600"
          role="progressbar"
          style={"width: #{@entry.progress}%"}
          aria-valuenow={@entry.progress}
          aria-valuemin="0"
          aria-valuemax="100"
        >
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def update(%{product: product} = assigns, socket) do
    {:ok,
     socket
     |> allow_upload(:photos,
       accept: ~w(.jpg .jpeg .png),
       max_entries: 5,
       external: &presign_upload/2,
       max_file_size: 10_000_000
     )
     |> assign(initial_assigns(assigns.action, product))
     |> assign(assigns)
     |> assign_form(Store.change_product(product))}
  end

  @impl true
  def handle_event(
        "validate",
        %{"type" => "set-description", "value" => description},
        socket
      ) do
    product = socket.assigns.product

    socket =
      assign(
        socket,
        :product,
        %{product | description: description}
      )

    {:noreply, socket}
  end

  @impl true
  def handle_event(
        "validate",
        %{"type" => "set-integer-price", "field" => field_name, "value" => value},
        socket
      ) do
    product = socket.assigns.product

    value = String.replace(value, ~r[\,|\.], "") |> String.to_integer()

    field = define_field(field_name)

    socket =
      assign(
        socket,
        :product,
        Map.put(product, String.to_atom(field), value)
      )

    {:noreply, socket}
  end

  @impl true
  def handle_event(
        "validate",
        %{"product" => product_params, "search_tag" => tag_name} = params,
        socket
      ) do
    product_params =
      product_params
      |> validate_custom_select(
        "status",
        socket.assigns.status_collection,
        params["select-status"]
      )
      |> validate_custom_select(
        "category",
        socket.assigns.categories_collection,
        params["select-category"]
      )
      |> validate_stock(params["put-stock"])

    changeset =
      socket.assigns.product
      |> Store.change_product(product_params)
      |> Map.put(:action, :validate)

    assigns =
      if tag_name == "" do
        [fetched_tags: [], tag_name: ""]
      else
        selected_tags = socket.assigns.selected_tags
        tags = socket.assigns.tags

        search_tags(tags, selected_tags, tag_name)
      end

    socket =
      socket
      |> assign_form(changeset)
      |> assign(
        :product,
        Ecto.Changeset.apply_changes(changeset)
      )
      |> assign(assigns)

    {:noreply, socket}
  end

  def handle_event("save", %{"product" => _product_params}, socket) do
    product_params =
      socket.assigns.product
      |> Map.put(:photos, put_photos_url(socket, %{}))
      |> Map.drop([:__meta__, :__struct__])

    save_product(socket, socket.assigns.action, product_params)
  end

  def handle_event("select-tag", %{"id" => tag_id}, socket) do
    tags = socket.assigns.tags
    tag = Enum.find(tags, &(&1.id == tag_id))
    selected_tags = socket.assigns.selected_tags ++ [tag]

    assigns = search_tags(tags, selected_tags, socket.assigns.tag_name)

    {:noreply, assign(socket, assigns)}
  end

  def handle_event("remove-tag", %{"id" => tag_id}, socket) do
    tags = socket.assigns.tags
    tag = Enum.find(tags, &(&1.id == tag_id))
    selected_tags = socket.assigns.selected_tags -- [tag]

    assigns = search_tags(tags, selected_tags, socket.assigns.tag_name)

    {:noreply, assign(socket, assigns)}
  end

  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :photos, ref)}
  end

  # Filters tags based on the search query and manages selected tags.
  defp search_tags(tags, selected_tags, tag_name) do
    [
      fetched_tags: Enum.filter(tags, &(&1.name =~ ~r/#{tag_name}/i)) -- selected_tags,
      selected_tags: selected_tags,
      tag_name: tag_name
    ]
  end

  # Handles S3 upload completion and associates photos with product.
  # Manages unique photo URLs and main photo selection.
  defp put_photos_url(socket, _product) do
    {completed, []} = uploaded_entries(socket, :photos)

    for entry <- completed do
      key = "digistab_store/products/#{entry.client_name}"

      dest = Path.join("https://#{s3_config().bucket}.s3.amazonaws.com", key)

      %{"url" => dest}
    end
  end

  @doc """
  Consumes the uploaded photo entries to mark them as processed and to clean up resources. This function is typically used after uploads have been successfully handled to perform any necessary cleanup or final processing.
  """
  def consume_photos(socket, product) do
    consume_uploaded_entries(socket, :photos, fn _meta, _entry ->
      :ok
    end)

    {:ok, product}
  end

  # Persists changes to a product based on the action (`:edit` or `:new`).
  defp save_product(socket, :edit, product_params) do
    product = Store.get_product!(socket.assigns.product.id)

    case Store.update_product(product, product_params) do
      {:ok, product} ->
        notify_parent({:saved, product |> Store.preload_product!()})

        {:noreply,
         socket
         |> put_flash(:info, "Product updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_product(socket, :new, product_params) do
    case Store.create_product(product_params) do
      {:ok, product} ->
        notify_parent({:saved, product |> Store.preload_product!()})

        {:noreply,
         socket
         |> put_flash(:info, "Product created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  # Configures initial state for product creation or editing.
  defp initial_assigns(:new, _product) do
    status_collection = DigistabStore.Store.list_status_collection()

    status =
      status_collection
      |> Enum.map(& &1.name)

    categories_collection = DigistabStore.Store.list_categories()

    categories =
      categories_collection
      |> Enum.map(& &1.name)

    tags = DigistabStore.Store.list_tags()

    [
      status: status,
      status_collection: status_collection,
      categories: categories,
      categories_collection: categories_collection,
      tags: tags,
      fetched_tags: [],
      selected_tags: [],
      tag_name: ""
    ]
  end

  defp initial_assigns(:edit, product) do
    status_collection = DigistabStore.Store.list_status_collection()

    status =
      status_collection
      |> Enum.map(& &1.name)

    categories_collection = DigistabStore.Store.list_categories()

    categories =
      categories_collection
      |> Enum.map(& &1.name)

    tags = DigistabStore.Store.list_tags()

    [
      status: status,
      status_collection: status_collection,
      categories: categories,
      categories_collection: categories_collection,
      tags: tags,
      fetched_tags: [],
      selected_tags: product.tags,
      tag_name: "",
      photos: product.photos
    ]
  end

  # Validates stock input, converting it to an integer when necessary.
  defp validate_stock(attrs, stock) when is_integer(stock) do
    %{attrs | "stock" => stock}
  end

  defp validate_stock(attrs, stock) do
    attrs
    |> Map.put("stock", String.to_integer(stock))
  end

  # Ensures selected values for custom fields are valid based on predefined collections.
  defp validate_custom_select(attrs, field, collection, value) do
    field_value = Enum.find(collection, fn st -> st.name == value end)

    Map.put(attrs, field, field_value)
    |> Map.put(field <> "_id", field_value.id)
  end

  # Selects an item from a list based on the provided ID.
  # If the ID is nil, returns the first item in the list.
  defp select_item(items, id) do
    if is_nil(id) do
      List.first(items)
    else
      Enum.find(items, &(&1.id == id))
    end
  end

  @doc """
  Checks if there are any ongoing uploads.
  """
  def has_uploads?(uploads), do: length(uploads) > 0

  # Determines the appropriate tailwind classes for the upload field based on its state.
  defp upload_field(true),
    do:
      "flex h-fit md:h-36 md:w-32 m-2 cursor-pointer rounded-md border-2 border-dashed border-gray-300 p-4 text-center"

  defp upload_field(false),
    do:
      "flex h-36 w-full cursor-pointer rounded-md border-2 border-dashed border-gray-300 p-4 text-center"

  # Truncates a filename if it exceeds a certain length.
  defp truncate_filename(filename) do
    if String.length(filename) < 19 do
      filename
    else
      filename
      |> String.split_at(16)
      |> Tuple.to_list()
      |> List.first()
      |> then(&"#{&1}...")
    end
  end

  # Prepares metadata needed for uploading files directly from the browser to S3.
  # This function handles generating a presigned URL and setting up the required
  # AWS fields for secure file uploads, as well as any necessary file restrictions.
  defp presign_upload(entry, socket) do
    uploads = socket.assigns.uploads

    case uploads[entry.upload_config] do
      nil ->
        {:error, :upload_cancelled}

      upload_config ->
        key = "digistab_store/products/#{entry.client_name}"

        {:ok, fields} =
          SimpleS3Upload.sign_form_upload(s3_config(), s3_config().bucket,
            key: key,
            content_type: entry.client_type,
            max_file_size: upload_config.max_file_size,
            expires_in: :timer.hours(1)
          )

        meta = %{
          uploader: "S3",
          key: key,
          url: "https://#{s3_config().bucket}.s3-#{s3_config().region}.amazonaws.com",
          fields: fields
        }

        {:ok, meta, socket}
    end
  end

  # s3 config params at runtime  execution
  def s3_config() do
    %{
      bucket: System.get_env("AWS_BUCKET_NAME"),
      region: System.get_env("AWS_REGION"),
      access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
      secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY")
    }
  end

  # Converts field names to atom keys used internally.
  defp define_field("put-price"), do: "price"
  defp define_field("put-promo-price"), do: "promotional_price"
end
