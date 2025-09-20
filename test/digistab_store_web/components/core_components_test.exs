defmodule DigistabStoreWeb.CoreComponentsTest do
  use DigistabStoreWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Phoenix.Component
  import Phoenix.HTML.Form
  import DigistabStoreWeb.CoreComponents

  describe "modal/1" do
    test "renders a modal with content" do
      assigns = %{id: "test-modal", show: false, on_cancel: %Phoenix.LiveView.JS{}}

      modal = ~H"""
      <.modal {assigns}>
        Test Modal Content
      </.modal>
      """

      html = rendered_to_string(modal)
      assert html =~ "Test Modal Content"
      assert html =~ "id=\"test-modal\""
      assert html =~ "phx-remove"
      assert html =~ "role=\"dialog\""
    end

    test "shows modal when true" do
      assigns = %{id: "test-modal", show: true, on_cancel: %Phoenix.LiveView.JS{}}

      modal = ~H"""
      <.modal {assigns}>
        Test Modal Content
      </.modal>
      """

      html = rendered_to_string(modal)
      assert html =~ "phx-mounted"
    end
  end

  describe "flash/1" do
    test "renders info flash" do
      assigns = %{id: "flash-info", kind: :info, flash: %{"info" => "Test Message"}}

      flash = ~H"""
      <.flash {assigns} />
      """

      html = rendered_to_string(flash)
      assert html =~ "Test Message"
      assert html =~ "id=\"flash-info\""
      assert html =~ "role=\"alert\""
      assert html =~ "bg-emerald-50"
    end

    test "renders error flash" do
      assigns = %{id: "flash-error", kind: :error, flash: %{"error" => "Test Message"}}

      flash = ~H"""
      <.flash {assigns} />
      """

      html = rendered_to_string(flash)
      assert html =~ "Test Message"
      assert html =~ "id=\"flash-error\""
      assert html =~ "bg-rose-50"
    end
  end

  describe "flash_group/1" do
    test "renders flash group with flash" do
      assigns = %{
        id: "flash-group",
        flash: %{"info" => "Info Message", "error" => "Error Message"}
      }

      flash_group = ~H"""
      <.flash_group {assigns} />
      """

      html = rendered_to_string(flash_group)
      assert html =~ "Info Message"
      assert html =~ "Error Message"
      assert html =~ "id=\"flash-group\""
      assert html =~ "id=\"flash-info\""
      assert html =~ "id=\"flash-error\""
    end
  end

  describe "simple_form/1" do
    test "renders form content" do
      assigns = %{for: %{}, as: nil, rest: []}

      form = ~H"""
      <.simple_form :let={f} {assigns}>
        <div>Form Content</div>
        <:actions>
          <button>Submit</button>
        </:actions>
      </.simple_form>
      """

      html = rendered_to_string(form)
      assert html =~ "Form Content"
      assert html =~ "<button>Submit</button>"
      assert html =~ "<form"
      assert html =~ "class=\"m-2 space-y-8"
    end
  end

  describe "button/1" do
    test "renders button content" do
      assigns = %{type: "button", class: "custom-class", rest: [disabled: true]}

      button = ~H"""
      <.button {assigns}>
        Click Me
      </.button>
      """

      html = rendered_to_string(button)
      assert html =~ "Click Me"
      assert html =~ "type=\"button\""
      assert html =~ "custom-class"
      assert html =~ "disabled"
    end
  end

  describe "input/1" do
    test "renders a text input" do
      form = to_form(%{"name" => ""}, as: :user)
      assigns = %{field: form[:name], id: "user-name", label: "Name", type: "text", errors: []}

      input = ~H"""
      <.input {assigns} />
      """

      html = rendered_to_string(input)
      assert html =~ "Name"
      assert html =~ "id=\"user-name\""
      assert html =~ "type=\"text\""
    end

    test "renders a checkbox input" do
      form = to_form(%{"active" => false}, as: :user)

      assigns = %{
        field: form[:active],
        id: "user-active",
        label: "Active",
        type: "checkbox",
        errors: []
      }

      input = ~H"""
      <.input {assigns} />
      """

      html = rendered_to_string(input)
      assert html =~ "Active"
      assert html =~ "id=\"user-active\""
      assert html =~ "type=\"checkbox\""
      assert html =~ "type=\"hidden\" name=\"user[active]\" value=\"false\""
    end

    test "renders a select input" do
      form = to_form(%{"role" => "user"}, as: :user)

      assigns = %{
        field: form[:role],
        id: "user-role",
        label: "Role",
        type: "select",
        prompt: "Select a role",
        options: [{"Admin", "admin"}, {"User", "user"}],
        multiple: false,
        errors: []
      }

      input = ~H"""
      <.input {assigns} />
      """

      html = rendered_to_string(input)
      assert html =~ "Role"
      assert html =~ "id=\"user-role\""
      assert html =~ "<select"
      assert html =~ "Select a role"
      assert html =~ "Admin"
      assert html =~ "User"
    end

    test "renders a textarea input" do
      form = to_form(%{"bio" => ""}, as: :user)
      assigns = %{field: form[:bio], id: "user-bio", label: "Bio", type: "textarea", errors: []}

      input = ~H"""
      <.input {assigns} />
      """

      html = rendered_to_string(input)
      assert html =~ "Bio"
      assert html =~ "id=\"user-bio\""
      assert html =~ "<textarea"
    end

    test "renders errors when present" do
      # Create a form with a field that has errors
      form_data = %{
        "email" => "",
        "errors" => [
          email: {"must be valid", []}
        ]
      }

      # Create a form with the field and its errors
      form =
        to_form(%{"email" => ""},
          as: :user,
          errors: [email: {"must be valid", []}]
        )

      form = Map.put(form, :action, :validate)
      field = Map.put(form[:email], :form, form)

      assigns = %{
        field: field,
        id: "user-email",
        label: "Email",
        type: "email"
      }

      input = ~H"""
      <.input {assigns} />
      """

      html = rendered_to_string(input)
      assert html =~ "must be valid"
      assert html =~ "hero-exclamation-circle-mini"
    end
  end

  describe "label/1" do
    test "renders a label content" do
      assigns = %{for: "user-name", weight: "font-bold"}

      label = ~H"""
      <.label {assigns}>
        User Name
      </.label>
      """

      html = rendered_to_string(label)
      assert html =~ "User Name"
      assert html =~ "for=\"user-name\""
      assert html =~ "font-bold"
    end
  end

  describe "error/1" do
    test "renders an error message" do
      assigns = %{}

      error = ~H"""
      <.error>
        This field is required
      </.error>
      """

      html = rendered_to_string(error)
      assert html =~ "This field is required"
      assert html =~ "hero-exclamation-circle-mini"
      assert html =~ "text-rose-600"
    end
  end

  describe "header/1" do
    test "renders a header with title" do
      assigns = %{class: "custom-header"}

      header = ~H"""
      <.header {assigns}>
        Page Title
        <:subtitle>
          Subtitle Text
        </:subtitle>
        <:actions>
          <button>Action</button>
        </:actions>
      </.header>
      """

      html = rendered_to_string(header)
      assert html =~ "Page Title"
      assert html =~ "Subtitle Text"
      assert html =~ "<button>Action</button>"
      assert html =~ "custom-header"
    end
  end

  describe "table/1" do
    test "renders a table with data rows" do
      assigns = %{
        id: "users-table",
        rows: [%{id: 1, name: "Alice"}, %{id: 2, name: "Bob"}]
      }

      table = ~H"""
      <.table {assigns}>
        <:col :let={user} label="ID"><%= user.id %></:col>
        <:col :let={user} label="Name"><%= user.name %></:col>
        <:action :let={user}>
          <button>Edit <%= user.name %></button>
        </:action>
      </.table>
      """

      html = rendered_to_string(table)
      assert html =~ "ID"
      assert html =~ "Name"
      assert html =~ "1"
      assert html =~ "Alice"
      assert html =~ "2"
      assert html =~ "Bob"
      assert html =~ "Edit Alice"
      assert html =~ "Edit Bob"
      assert html =~ "id=\"users-table\""
    end
  end

  describe "list/1" do
    test "renders a list with items" do
      assigns = %{}

      list = ~H"""
      <.list>
        <:item title="Name">John Doe</:item>
        <:item title="Email">john@example.com</:item>
      </.list>
      """

      html = rendered_to_string(list)
      assert html =~ "Name"
      assert html =~ "John Doe"
      assert html =~ "Email"
      assert html =~ "john@example.com"
      assert html =~ "<dl"
    end
  end

  describe "back/1" do
    test "renders a back navigation link" do
      assigns = %{navigate: "/products"}

      back = ~H"""
      <.back {assigns}>
        Back to Products
      </.back>
      """

      html = rendered_to_string(back)
      assert html =~ "Back to Products"
      assert html =~ "hero-arrow-left-solid"
      assert html =~ "href=\"/products\""
    end
  end

  describe "icon/1" do
    test "renders a heroicon" do
      assigns = %{name: "hero-x-mark-solid", class: "w-6 h-6"}

      icon = ~H"""
      <.icon {assigns} />
      """

      html = rendered_to_string(icon)
      assert html =~ "hero-x-mark-solid"
      assert html =~ "w-6 h-6"
    end
  end
end
