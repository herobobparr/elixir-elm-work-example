defmodule Usd2rur.CurrencyView do
  use Usd2rur.Web, :view
  require Logger

  def render("bank_list.json", %{bank_list: bank_list}) do
      render_many bank_list, Usd2rur.CurrencyView, "bank.json", as: :bank
  end

  def render("bank.json", %{bank: bank}) do
      %{ name: bank.name, slug: bank.slug }
  end
end