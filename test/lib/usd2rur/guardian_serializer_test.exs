defmodule Usd2rur.GuardianSerializerTest do
  use ExUnit.Case, async: true
  use Usd2rur.ModelCase
  alias Usd2rur.Repo
  alias Usd2rur.User
  alias Usd2rur.GuardianSerializer
  require Logger

  setup do
    changeset = User.changeset(
      %User{},
      %{
        "username" => "test",
        "password" => "asdf123",
        "password_confirmation" => "asdf123"
      }
    )
    {:ok, user} = Repo.insert(changeset)
    {:ok, [user: user]}
  end

  test "Serializer to token success", %{user: user} do
    assert {:ok, _} = GuardianSerializer.for_token(user)
  end

  test "Serializer to token fail" do
    assert {:error, _} = GuardianSerializer.for_token("fake")
  end

  test "Serializer from token success", %{user: user} do
    {:ok, data}= JSON.encode(%{"id" => user.id, "username" => user.username})
    assert {:ok, user} = GuardianSerializer.from_token(data)
  end

  test "Serializer from token error" do
    assert {:error, _} = GuardianSerializer.from_token("")
  end
end