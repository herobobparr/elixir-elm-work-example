defmodule Usd2rur.CrawlStrategy.TinkoffTest do
  use ExUnit.Case, async: true
  alias Usd2rur.CrawlStrategy.Tinkoff

  test "response success json parsed" do
    success_data = [
      payload: [
        rates: [
          [
            category: "DebitCardsTransfers",
            fromCurrency: [code: 840],
            toCurrency: [code: 643],
            buy: 63.4,
            sell: 64.4
          ]
        ]
      ]
    ]
    {:ok, json} = JSON.encode(success_data)

    response = %HTTPoison.Response{
      status_code: 200,
      body: json
    }

    assert {:ok, [buy_value: 63.4, sell_value: 64.4]} = Tinkoff.parse({:ok, response})
  end

  test "wrong json data" do
    success_data = [
      payload: [
        fake: "test"
      ]
    ]

    {:ok, json} = JSON.encode(success_data)
    response = %HTTPoison.Response{
      status_code: 200,
      body: json
    }

    assert {:error, :wrong_json_structure, _} = Tinkoff.parse({:ok, response})
  end

  test "cant find currency, by category" do
    success_data = [
      payload: [
        rates: [
          [
            category: "FakeCategory",
            fromCurrency: [code: 840],
            toCurrency: [code: 643],
            buy: 63.4,
            sell: 64.4
          ]
        ]
      ]
    ]

    {:ok, json} = JSON.encode(success_data)
    response = %HTTPoison.Response{
      status_code: 200,
      body: json
    }

    assert {:error, :wrong_json_structure, _} = Tinkoff.parse({:ok, response})
  end

  test "response success not a json data" do
    response = %HTTPoison.Response{
      status_code: 200,
      body: "Not a json, Mama"
    }

    assert {:error, :cant_parse_json, _} = Tinkoff.parse({:ok, response})
  end

  test "fail response" do
    response = %HTTPoison.Response{
      status_code: 404,
      body: "Not Found"
    }

    assert {:error, :wrong_server_response, _} = Tinkoff.parse({:ok, response})
  end

  test "another error" do
    assert {:error, :server_request_error, _} = Tinkoff.parse("something else")
  end
end
