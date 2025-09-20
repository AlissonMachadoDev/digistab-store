defmodule DigistabStoreWeb.PageControllerTest do
  use DigistabStoreWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 302) =~ "You are being <a href=\"/products\">redirected</a>."
  end
end
