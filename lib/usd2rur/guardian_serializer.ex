defmodule Usd2rur.GuardianSerializer do
  alias Usd2rur.User
  alias Usd2rur.Repo

  def for_token(user = %User{}) do
    JSON.encode(%{
      "id" => user.id,
      "username" => user.username
    })
  end

   def for_token(_) do
     {:error, "Unknown resource type"}
   end

   def from_token(token) do
     case JSON.decode(token) do
       {:ok, %{ "id" => id, "username" => _}} ->
         {:ok, Repo.get(User, id)}
       _ ->
         {:error, "Unknown resource type"}
     end
   end
end