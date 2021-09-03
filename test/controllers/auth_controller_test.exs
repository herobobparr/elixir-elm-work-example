defmodule Usd2rur.AuthControllerTest do
  use Usd2rur.ConnCase
  alias Usd2rur.Repo
  alias Usd2rur.User

  setup %{conn: conn} do
    changeset = User.changeset(
      %User{},
      %{
        "username" => "test",
        "password" => "asdf123",
        "password_confirmation" => "asdf123"
      }
    )
    {:ok, user} = Repo.insert(changeset)
    {:ok, [conn: conn, user: user]}
  end

  describe "POST /api/auth/login" do
    test "success", %{conn: conn} do
      params = [
        username: "test",
        password: "asdf123"
      ]
      conn = post conn, "/api/auth/login", params
      assert json_response(conn, 200)
    end

    test "fail", %{conn: conn} do
      params = [
        username: "fake",
        password: "fake"
      ]
      conn = post conn, "/api/auth/login", params
      assert json_response(conn, 400)
    end
  end
end