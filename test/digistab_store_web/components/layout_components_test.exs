defmodule DigistabStoreWeb.Layouts.LayoutComponentsTest do
  use DigistabStoreWeb.ConnCase, async: true
  import Phoenix.LiveViewTest
  import DigistabStoreWeb.Layouts.LayoutComponents
  import Phoenix.Template

  describe "navbar/1" do
    test "renders with categories" do
      category1 = %{id: "1", name: "Electronics"}
      category2 = %{id: "2", name: "Books"}

      assigns = %{categories: [category1, category2]}

      html = render_component(&navbar/1, assigns)

      # Verify header structure
      assert html =~ "header"
      assert html =~ "fixed top-0 left-10 right-10"
      assert html =~ "navbar"

      # Verify logo link
      assert html =~ ~s|href="/products"|
      assert html =~ "/images/plain_logo.svg"

      # Verify cart button
      # cart count
      assert html =~ "10"
      assert html =~ "hero-shopping-cart"

      # Verify categories button
      assert html =~ "Categories"
      assert html =~ "hero-chevron-down"

      # Verify account button
      assert html =~ "My account"

      # Verify Alpine.js attributes
      assert html =~ "x-data"
      assert html =~ "categories: false"
      assert html =~ "@click=\"categories = !categories\""

      # Verify categories dropdown
      assert html =~ category1.name
      assert html =~ category2.name
      assert html =~ ~s|href="/products/categories/#{category1.id}"|
      assert html =~ ~s|href="/products/categories/#{category2.id}"|
    end

    test "renders with empty categories list" do
      assigns = %{categories: []}

      html = render_component(&navbar/1, assigns)

      assert html =~ "Categories"
      refute html =~ "bg-violet-100"
    end

    test "verifies cart button is disabled" do
      assigns = %{categories: []}

      html = render_component(&navbar/1, assigns)

      assert html =~ "cursor-not-allowed"
    end

    test "verifies account button is disabled" do
      assigns = %{categories: []}

      html = render_component(&navbar/1, assigns)

      assert html =~ "cursor-not-allowed"
      assert html =~ "My account"
    end
  end

  describe "footer/1" do
    test "renders footer with branding and technologies" do
      assigns = %{}

      html = render_component(&footer/1, assigns)

      # Verify footer structure
      assert html =~ "<footer"
      assert html =~ "bg-gradient-to-t from-violet-400 to-white"

      # Verify logo
      assert html =~ "/images/logo.svg"

      # Verify disclaimer text
      assert html =~ "Digistab Store is a fictional brand"
      assert html =~ "Alisson Machado"

      # Verify technologies section
      assert html =~ "Technologies"
      assert html =~ "Elixir"
      assert html =~ "Phoenix"
      assert html =~ "Liveview"
      assert html =~ "Tailwind"
      assert html =~ "AlpineJS"
      assert html =~ "PostgreSQL"

      # Verify grid layout for technologies
      assert html =~ "grid grid-cols-2 gap-x-4 gap-y-1"

      # Verify separator
      assert html =~ "border-2 border-violet-700"
    end

    test "verifies responsive layout classes" do
      assigns = %{}

      html = render_component(&footer/1, assigns)

      # Verify mobile-first responsive classes
      assert html =~ "flex-col-reverse"
      assert html =~ "md:flex-row"
      assert html =~ "md:justify-between"
      assert html =~ "md:flex-row md:w-1/2"
    end
  end

  describe "component rendering with Alpine.js" do
    test "navbar includes Alpine.js initialization" do
      assigns = %{categories: []}

      html = render_component(&navbar/1, assigns)

      # Check for Alpine.js data initialization
      assert html =~ "x-id=\"['navbar']\""
      assert html =~ "x-data="

      # Check for Alpine directives
      assert html =~ "x-ref=\"button_categories\""
      assert html =~ "x-bind:aria-expanded=\"categories\""
      assert html =~ "x-bind:id=\"$id('navbar')\""
      assert html =~ "x-transition.origin.top.left"
    end
  end

  describe "app layout integration" do
    test "app.html.heex renders with navbar and footer" do
      conn = build_conn()

      # Mock layout rendering with components
      assigns = %{
        conn: conn,
        inner_content: {:safe, "Test content"},
        flash: %{}
      }

      html = render_to_string(DigistabStoreWeb.Layouts, "app", "html", assigns)

      # Verify main content wrapper
      assert html =~ "main"
      assert html =~ "Test content"

      # Verify max-width container
      assert html =~ "max-w-2/3"

      # Verify padding classes
      assert html =~ "px-4 py-20"
      assert html =~ "sm:px-6 lg:px-8"
    end
  end
end
