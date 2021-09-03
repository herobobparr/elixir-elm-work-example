defmodule Usd2rur.User do
  use Usd2rur.Web, :model
  alias Usd2rur.Repo
  require Logger

  schema "users" do
    field :username, :string
    field :password, :binary

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :password])
    |> validate_required([:username, :password])
    |> validate_length(:username, min: 4)
    |> validate_length(:username, max: 20)
    |> validate_length(:password, min: 6)
    |> validate_length(:password, max: 50)
    |> validate_confirmation(:password, [message: "does not match password", required: true])
    |> unique_constraint(:username)
    |> encode_change_password()
  end

  def find_user_with_password(%{ "username" => username, "password" => password }) do
    encoded_password = encode_password(password)
    Repo.get_by(__MODULE__, [username: username, password: encoded_password])
  end

  defp encode_password(password) do
    Logger.debug "Encode password"
    salt = Application.get_env(:usd2rur, :salt)
    :crypto.md5(salt <> password)
  end

  defp encode_change_password(changeset) do
    if changeset.valid? do
      password = get_change(changeset, :password)
      put_change(
        changeset,
        :password,
        encode_password(password)
      )
    else
      changeset
    end
  end

end
