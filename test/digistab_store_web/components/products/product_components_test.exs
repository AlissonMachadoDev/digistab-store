defmodule DigistabStoreWeb.ProductLive.ProductComponentsTest do
  use DigistabStoreWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  alias DigistabStoreWeb.ProductLive.ProductComponents
  alias DigistabStoreWeb.ProductLive.FormComponent
  alias Phoenix.LiveView.JS

  describe "product_modal/1" do
    test "renders modal with required attributes" do
      assigns = %{
        id: "test-modal",
        show: true,
        on_cancel: %JS{},
        on_confirm: %JS{},
        inner_block: [
          %{__slot__: :inner_block, inner_block: fn _, _ -> "Modal content" end}
        ],
        title: [],
        subtitle: [],
        confirm: [],
        cancel: []
      }

      rendered = render_component(&ProductComponents.product_modal/1, assigns)

      assert rendered =~ "test-modal"
      assert rendered =~ "Modal content"
      assert rendered =~ "relative z-50 hidden"
    end

    test "renders modal with title and subtitle" do
      assigns = %{
        id: "test-modal",
        show: true,
        on_cancel: %JS{},
        on_confirm: %JS{},
        inner_block: [
          %{__slot__: :inner_block, inner_block: fn _, _ -> "Modal content" end}
        ],
        title: [%{__slot__: :title, inner_block: fn _assigns, _ -> "Test Title" end}],
        subtitle: [%{__slot__: :subtitle, inner_block: fn _assigns, _ -> "Test Subtitle" end}],
        confirm: [],
        cancel: []
      }

      rendered = render_component(&ProductComponents.product_modal/1, assigns)

      assert rendered =~ "Test Title"
      assert rendered =~ "Test Subtitle"
      assert rendered =~ "test-modal-title"
      assert rendered =~ "test-modal-description"
    end

    test "renders modal with confirm and cancel actions" do
      assigns = %{
        id: "test-modal",
        show: true,
        on_cancel: %JS{},
        on_confirm: %JS{},
        inner_block: [
          %{__slot__: :inner_block, inner_block: fn _, _ -> "Modal content" end}
        ],
        title: [],
        subtitle: [],
        confirm: [%{__slot__: :confirm, inner_block: fn _assigns, _ -> "Confirm" end}],
        cancel: [%{__slot__: :cancel, inner_block: fn _assigns, _ -> "Cancel" end}]
      }

      rendered = render_component(&ProductComponents.product_modal/1, assigns)

      assert rendered =~ "Confirm"
      assert rendered =~ "Cancel"
      assert rendered =~ "bg-green-400"
      assert rendered =~ "bg-gray-400"
    end

    test "applies custom class to modal" do
      assigns = %{
        id: "test-modal",
        show: true,
        on_cancel: %JS{},
        on_confirm: %JS{},
        inner_block: [
          %{__slot__: :inner_block, inner_block: fn _, _ -> "Modal content" end}
        ],
        title: [],
        subtitle: [],
        confirm: [],
        cancel: [],
        class: "custom-width"
      }

      rendered = render_component(&ProductComponents.product_modal/1, assigns)

      assert rendered =~ "custom-width w-full p-4"
    end
  end

  describe "product_input/1 with type select_with_description" do
    test "renders select with description element correctly" do
      collection = [
        %{id: "1", name: "Status1", description: "First status"},
        %{id: "2", name: "Status2", description: "Second status"}
      ]

      assigns = %{
        id: "test-select",
        name: "test-select",
        field: %Phoenix.HTML.FormField{
          field: :test_field,
          form: %Phoenix.HTML.Form{
            source: %{},
            name: :product,
            data: %{},
            id: "product-form",
            errors: [],
            options: []
          },
          id: "test-select",
          name: "test-select",
          value: "Status1",
          errors: []
        },
        type: "select_with_description",
        label: "Test Select",
        value: "Status1",
        item: "Status1",
        collection: collection,
        options: ["Status1", "Status2"],
        errors: [],
        multiple: false,
        rest: []
      }

      rendered = render_component(&ProductComponents.product_input/1, assigns)

      assert rendered =~ "Test Select"
      assert rendered =~ "test-select"
      assert rendered =~ "First status"
      refute rendered =~ "Second status"
      assert rendered =~ "<option selected value=\"Status1\">"
    end
  end

  describe "product_input/1 with type wysiwyg" do
    test "renders wysiwyg editor correctly" do
      assigns = %{
        id: "test-wysiwyg",
        name: "test-wysiwyg",
        field: %Phoenix.HTML.FormField{
          field: :test_field,
          form: %Phoenix.HTML.Form{
            source: %{},
            name: :product,
            data: %{},
            id: "product-form",
            errors: [],
            options: []
          },
          id: "test-wysiwyg",
          name: "test-wysiwyg",
          value: "Test content",
          errors: []
        },
        type: "wysiwyg",
        label: "WYSIWYG Editor",
        value: "Test content",
        errors: [],
        rest: []
      }

      rendered = render_component(&ProductComponents.product_input/1, assigns)

      assert rendered =~ "WYSIWYG Editor"
      assert rendered =~ "phx-hook=\"TrixEditor\""
      assert rendered =~ "Test content"
      assert rendered =~ "trix-editor"
      assert rendered =~ "trix-toolbar"
    end

    test "renders with error styling when field has errors" do
      assigns = %{
        id: "test-wysiwyg",
        name: "test-wysiwyg",
        field: %Phoenix.HTML.FormField{
          field: :test_field,
          form: %Phoenix.HTML.Form{
            source: %{},
            name: :product,
            data: %{},
            id: "product-form",
            errors: [],
            options: []
          },
          id: "test-wysiwyg",
          name: "test-wysiwyg",
          value: "Test content",
          errors: [{"is required", []}]
        },
        type: "wysiwyg",
        label: "WYSIWYG Editor",
        value: "Test content",
        errors: ["is required"],
        rest: []
      }

      rendered = render_component(&ProductComponents.product_input/1, assigns)

      assert rendered =~ "border-rose-400"
      assert rendered =~ "is required"
    end
  end

  describe "product_input/1 with type price" do
    test "renders price input correctly" do
      assigns = %{
        id: "test-price",
        name: "test-price",
        field: %Phoenix.HTML.FormField{
          field: :test_field,
          form: %Phoenix.HTML.Form{
            source: %{},
            name: :product,
            data: %{},
            id: "product-form",
            errors: [],
            options: []
          },
          id: "test-price",
          name: "test-price",
          value: 1000,
          errors: []
        },
        type: "price",
        label: "Price",
        currency: "$",
        errors: [],
        rest: []
      }

      rendered = render_component(&ProductComponents.product_input/1, assigns)

      assert rendered =~ "Price"
      assert rendered =~ "R$"
      assert rendered =~ "test-price"
      assert rendered =~ "phx-hook=\"IntegerPriceInput\""
      assert rendered =~ "currency=\"$\""
    end

    test "formats price value based on currency" do
      assigns = %{
        id: "test-price",
        name: "test-price",
        field: %Phoenix.HTML.FormField{
          field: :test_field,
          form: %Phoenix.HTML.Form{
            source: %{},
            name: :product,
            data: %{},
            id: "product-form",
            errors: [],
            options: []
          },
          id: "test-price",
          name: "test-price",
          value: 0,
          errors: []
        },
        type: "price",
        label: "Price",
        currency: "$",
        errors: [],
        rest: []
      }

      rendered = render_component(&ProductComponents.product_input/1, assigns)

      assert rendered =~ "value=\"0.00\""
    end
  end

  describe "product_input/1 with type custom_counter" do
    test "renders custom counter correctly" do
      assigns = %{
        id: "test-counter",
        name: "test-counter",
        field: %Phoenix.HTML.FormField{
          field: :test_field,
          form: %Phoenix.HTML.Form{
            source: %{},
            name: :product,
            data: %{},
            id: "product-form",
            errors: [],
            options: []
          },
          id: "test-counter",
          name: "test-counter",
          value: 0,
          errors: []
        },
        type: "custom_counter",
        label: "Counter",
        errors: [],
        rest: []
      }

      rendered = render_component(&ProductComponents.product_input/1, assigns)

      assert rendered =~ "Counter"
      assert rendered =~ "test-counter"
      assert rendered =~ "phx-hook=\"CustomCounterInput\""
      assert rendered =~ "data-action=\"increment\""
      assert rendered =~ "data-action=\"decrement\""
      assert rendered =~ "value=\"0\""
    end

    test "renders with error styling when field has errors" do
      assigns = %{
        id: "test-counter",
        name: "test-counter",
        field: %Phoenix.HTML.FormField{
          field: :test_field,
          form: %Phoenix.HTML.Form{
            source: %{},
            name: :product,
            data: %{},
            id: "product-form",
            errors: [],
            options: []
          },
          id: "test-counter",
          name: "test-counter",
          value: 0,
          errors: [{"is required", []}]
        },
        type: "custom_counter",
        label: "Counter",
        errors: ["is required"],
        rest: []
      }

      rendered = render_component(&ProductComponents.product_input/1, assigns)

      assert rendered =~ "border-rose-400"
      assert rendered =~ "is required"
    end
  end

  describe "product_input/1 with type number" do
    test "renders number input correctly" do
      assigns = %{
        id: "test-number",
        name: "test-number",
        field: %Phoenix.HTML.FormField{
          field: :test_field,
          form: %Phoenix.HTML.Form{
            source: %{},
            name: :product,
            data: %{},
            id: "product-form",
            errors: [],
            options: []
          },
          id: "test-number",
          name: "test-number",
          value: 0,
          errors: []
        },
        type: "number",
        label: "Number Input",
        errors: [],
        rest: []
      }

      rendered = render_component(&ProductComponents.product_input/1, assigns)

      assert rendered =~ "Number Input"
      assert rendered =~ "test-number"
      assert rendered =~ "type=\"number\""
      assert rendered =~ "value=\"0\""
    end
  end

  describe "tag_selector/1" do
    test "renders empty state when no tags or fetched tags" do
      assigns = %{
        tags: [],
        fetched_tags: [],
        selected_tags: [],
        tag_name: "search term",
        myself: __MODULE__
      }

      rendered = render_component(&FormComponent.tag_selector/1, assigns)

      assert rendered =~ "value=\"search term\""
    end
  end

  describe "live_upload/1" do
    test "renders upload area when no entries exist" do
      assigns = %{
        uploads: %Phoenix.LiveView.UploadConfig{ref: "test-ref", entries: []},
        myself: __MODULE__
      }

      rendered = render_component(&FormComponent.live_upload/1, assigns)

      assert rendered =~ "browse the files"
      assert rendered =~ "max files: 5"
      assert rendered =~ "phx-drop-target"
      # Note: Can't test exact CSS classes without a proper upload config implementation
    end

    test "renders preview images when entries exist" do
      entries = [
        %Phoenix.LiveView.UploadEntry{
          ref: "entry-1",
          client_name: "test-file.jpg",
          progress: 50,
          upload_config: "photos"
        }
      ]

      assigns = %{
        uploads: %Phoenix.LiveView.UploadConfig{
          ref: "photos",
          entries: entries,
          errors: []
        },
        myself: __MODULE__
      }

      rendered = render_component(&FormComponent.live_upload/1, assigns)

      assert rendered =~ "test-file.jpg"
      assert rendered =~ "progress-bar"
      assert rendered =~ "width: 50%"
      assert rendered =~ "Add more..."
    end

    test "renders errors when upload errors exist" do
      assigns = %{
        uploads: %Phoenix.LiveView.UploadConfig{
          ref: "photos",
          entries: [],
          errors: [:too_many_files]
        },
        myself: __MODULE__
      }

      rendered = render_component(&FormComponent.live_upload/1, assigns)

      assert rendered =~ "bg-red-200"
      # Note: Can't test exact error messages without importing error_to_string function
    end

    test "limits entries display to 5" do
      entries =
        for i <- 1..6,
            do: %Phoenix.LiveView.UploadEntry{
              ref: "entry-#{i}",
              client_name: "file-#{i}.jpg",
              progress: 100,
              upload_config: "photos"
            }

      assigns = %{
        uploads: %Phoenix.LiveView.UploadConfig{
          ref: "photos",
          entries: entries,
          errors: []
        },
        myself: __MODULE__
      }

      rendered = render_component(&FormComponent.live_upload/1, assigns)

      refute rendered =~ "Add more..."
      # Should only show upload field when less than 5 entries
    end
  end

  describe "image_live_preview/1" do
    test "renders image preview with cancel button" do
      assigns = %{
        entry: %Phoenix.LiveView.UploadEntry{
          ref: "test-ref",
          client_name: "test-image.jpg",
          progress: 75
        },
        myself: __MODULE__
      }

      rendered = render_component(&FormComponent.image_live_preview/1, assigns)

      assert rendered =~ "test-image.jpg"
      assert rendered =~ "phx-click=\"cancel-upload\""
      assert rendered =~ "phx-value-ref=\"test-ref\""
      assert rendered =~ "width: 75%"
      assert rendered =~ "bg-red-400"
    end

    test "truncates long filenames" do
      assigns = %{
        entry: %Phoenix.LiveView.UploadEntry{
          ref: "test-ref",
          client_name: "very_long_filename_that_needs_to_be_truncated.jpg",
          progress: 100
        },
        myself: __MODULE__
      }

      rendered = render_component(&FormComponent.image_live_preview/1, assigns)

      assert rendered =~ "very_long_filena..."
      assert rendered =~ "very_long_filename_that_needs_to_be_truncated.jpg"
    end

    test "shows full filename when it's short enough" do
      assigns = %{
        entry: %Phoenix.LiveView.UploadEntry{
          ref: "test-ref",
          client_name: "short.jpg",
          progress: 100
        },
        myself: __MODULE__
      }

      rendered = render_component(&FormComponent.image_live_preview/1, assigns)

      assert rendered =~ "short.jpg"
      refute rendered =~ "..."
    end
  end
end
