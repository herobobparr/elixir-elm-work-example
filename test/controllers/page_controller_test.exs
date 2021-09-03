defmodule Usd2rur.PageControllerTest do
  use Usd2rur.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Usd2rur!"
  end
end
