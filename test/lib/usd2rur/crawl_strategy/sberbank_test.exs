defmodule Usd2rur.CrawlStrategy.SberbankTest do
  use ExUnit.Case, async: true
  alias Usd2rur.CrawlStrategy.Sberbank

  test "response success json parsed" do
    success_data = [
      beznal: [
        "840": [
          "0": [
            buyValue: 63.4,
            sellValue: 64.4
          ]
        ]
      ]
    ]
    {:ok, json} = JSON.encode(success_data)

    response = %HTTPoison.Response{
      status_code: 200,
      body: json
    }

    assert {:ok, [buy_value: 63.4, sell_value: 64.4]} = Sberbank.parse({:ok, response})
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

    assert {:error, :wrong_json_structure, _} = Sberbank.parse({:ok, response})
  end

  test "response success not a json data" do
    response = %HTTPoison.Response{
      status_code: 200,
      body: "Not a json, Mama"
    }

    assert {:error, :cant_parse_json, _} = Sberbank.parse({:ok, response})
  end

  test "fail response" do
    response = %HTTPoison.Response{
      status_code: 404,
      body: "Not Found"
    }

    assert {:error, :wrong_server_response, _} = Sberbank.parse({:ok, response})
  end

  test "another error" do
    assert {:error, :server_request_error, _} = Sberbank.parse("something else")
  end
end
