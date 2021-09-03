defmodule Usd2rur.AuthController do
  use Usd2rur.Web, :controller
  alias Usd2rur.CrawlStrategy
  alias Usd2rur.User

  def login(conn, params) do
    case User.find_user_with_password(params) do
      user = %User{} ->
        new_conn = Guardian.Plug.api_sign_in(conn, user)
        jwt = Guardian.Plug.current_token(new_conn)
        {:ok, claims} = Guardian.Plug.claims(new_conn)
        exp = Map.get(claims, "exp")
        conn
          |> put_status(200)
          |> json(%{ "token" => jwt, "exp" => exp })
      _ ->
        conn
          |> put_status(400)
          |> json(%{ "error" => "Login failed" })
    end
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> json(%{"error" => "Authentication required"})
  end
end