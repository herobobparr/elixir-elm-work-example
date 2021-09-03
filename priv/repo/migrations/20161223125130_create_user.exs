defmodule Usd2rur.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :password, :binary

      timestamps()
    end
    create unique_index(:users, [:username])

  end
end
