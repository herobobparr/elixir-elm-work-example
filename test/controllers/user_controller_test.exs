defmodule Usd2rur.UserControllerTest do
  use Usd2rur.ConnCase

  test "POST /api/user/ error", %{conn: conn} do
    conn = post conn, "/api/user/", %{}
    assert json_response(conn, 400)
  end

  test "POST /api/user/ success", %{conn: conn} do
    params = [
      username: "fake",
      password: "test12",
      password_confirmation: "test12"
    ]
    conn = post conn, "/api/user/", params
    assert json_response(conn, 200)
  end
end
