defmodule Usd2rur.UserTest do
  use Usd2rur.ModelCase
  alias Usd2rur.User
  alias Usd2rur.Repo
  require Logger

  @valid_attrs %{password: "asdf123", password_confirmation: "asdf123", username: "zapix"}
  @invalid_attrs %{}
  @password_do_not_match %{password: "asdf123'", password_confirmation: "123", username: "zapix"}

  def on_exit(_name_or_ref, _callback) do
    Logger.warn "ON exit handling"
  end

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "password do not match" do
    changeset = User.changeset(%User{}, @password_do_not_match)
    refute changeset.valid?
  end

  test "not find user" do
    refute User.find_user_with_password(%{ "username" => "test", "password" => "test123"})
  end

  test "user found" do
    changeset = User.changeset(%User{}, @valid_attrs)
    {:ok, _ } = Repo.insert(changeset)

    assert User.find_user_with_password(%{ "username" => "zapix", "password" => "asdf123"})
  end
end
