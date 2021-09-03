defmodule Usd2rur.CrawlStrategy.AlphaBankTest do
  use ExUnit.Case, async: true
  alias Usd2rur.CrawlStrategy.AlphaBank

  test "response success json parsed" do
    success_data = [
      response: [
        data: [
          usd: [
            [type: "buy", value: 63.4],
            [type: "sell", value: 64.4]
          ]
        ]
      ]
    ]
    {:ok, json} = JSON.encode(success_data)

    response = %HTTPoison.Response{
      status_code: 200,
      body: json
    }

    assert {:ok, [buy_value: 63.4, sell_value: 64.4]} = AlphaBank.parse({:ok, response})
  end

  test "response success json wrong structure" do
    success_data = [
      response: [
        error: 1
      ]
    ]

    {:ok, json} = JSON.encode(success_data)
    response = %HTTPoison.Response{
      status_code: 200,
      body: json
    }

    assert {:error, :wrong_json_structure, _} = AlphaBank.parse({:ok, response})
  end

  test "response success not a json data" do
    response = %HTTPoison.Response{
      status_code: 200,
      body: "Not a json, Mama"
    }

    assert {:error, :cant_parse_json, _} = AlphaBank.parse({:ok, response})
  end

  test "fail response" do
    response = %HTTPoison.Response{
      status_code: 404,
      body: "Not Found"
    }

    assert {:error, :wrong_server_response, _} = AlphaBank.parse({:ok, response})
  end

  test "another error" do
    assert {:error, :server_request_error, _} = AlphaBank.parse("something else")
  end
end