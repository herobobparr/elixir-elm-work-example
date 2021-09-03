defmodule Usd2rur.Repo do
  use Ecto.Repo, otp_app: :usd2rur
  @dialyzer {:nowarn_function, rollback: 1, insert_or_update: 2, insert_or_update!: 2}
end
