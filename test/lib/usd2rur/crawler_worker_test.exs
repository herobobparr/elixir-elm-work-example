defmodule Usd2rur.CrawlerWorkerTest do
  use ExUnit.Case, async: true
  import Mock
  alias Usd2rur.CrawlerWorker

  setup do
    {:ok, crawler} = CrawlerWorker.start_link
    {:ok, crawler: crawler}
  end

  test "get data", %{crawler: crawler} do
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

    with_mock HTTPoison, [get: fn _url -> {:ok, response} end] do
      assert {:ok, _} = CrawlerWorker.crawl(crawler, 'http://fakeurl.com/test')
      assert 1 = CrawlerWorker.show_calls(crawler)
    end
  end
end