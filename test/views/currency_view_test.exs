defmodule Usd2rur.CurrencyViewTest do
  use Usd2rur.ConnCase, async: true
  alias Usd2rur.CrawlStrategy

  import Phoenix.View

  test "render one bank data" do
    assert render_to_string(
      Usd2rur.CurrencyView,
      "bank.json",
      %{bank: CrawlStrategy.AlphaBank}
    ) == String.trim """
    {"slug":"alpha","name":"Alpha"}
    """
  end

  test "render multiple bank data" do
    alpha_json = render_to_string(
      Usd2rur.CurrencyView,
      "bank.json",
      %{bank: CrawlStrategy.AlphaBank}
    )
    tinkoff_json = render_to_string(
        Usd2rur.CurrencyView,
        "bank.json",
        %{bank: CrawlStrategy.Tinkoff}
    )

    expected_string = "[#{alpha_json},#{tinkoff_json}]"

    bank_list = [CrawlStrategy.AlphaBank, CrawlStrategy.Tinkoff]
    assert render_to_string(
      Usd2rur.CurrencyView,
      "bank_list.json",
      %{bank_list: bank_list}
    ) == expected_string
  end
end