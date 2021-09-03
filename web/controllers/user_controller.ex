defmodule Usd2rur.UserController do
  use Usd2rur.Web, :controller
  alias Usd2rur.User
  alias Usd2rur.Repo
  require Logger
  require Atom

  def create(conn, params) do
    Logger.info "Create user with #{inspect params}"

    changeset = User.changeset(%User{}, params)

    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
          |> put_status(200)
          |> json(%{"status" => "user created"})
      {:error, changeset} ->
        errors = changeset.errors
          |> Enum.map(fn {key, {value, _}} -> {Atom.to_string(key), value}  end)
          |> Enum.reduce(%{}, fn {key, value}, acc -> Map.put(acc, key, value)  end)
        conn
          |> put_status(:bad_request)
          |> json(errors)
    end
  end
end