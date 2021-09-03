defmodule Usd2rur.BankWorkerTest do
  use ExUnit.Case
  use Timex
  import Mock
  alias Usd2rur.BankWorker
  require Logger

  defmodule FakeBank do
    def name do
      "Fake"
    end

    def slug do
      "fake"
    end

    def url do
      "http://fake-bank.com/api/currency"
    end

    def parse({:ok, %HTTPoison.Response{ status_code: 200, body: body }}) do
      {:ok, %{ "buy_value" => buy_value, "sell_value" => sell_value }} = JSON.decode(body)
      {:ok, [buy_value: buy_value, sell_value: sell_value]}
    end

    def parse({:ok, _}) do
      {:error, "Some error"}
    end

  end

  test "load currency on server start success" do
    success_data = [
      buy_value: 63.4,
      sell_value: 64.4
    ]
    {:ok, json} = JSON.encode(success_data)

    response = %HTTPoison.Response{
      status_code: 200,
      body: json
    }

    with_mock :poolboy, [transaction: fn (:crawler_pool, _fake) -> {:ok, response} end] do
      {:ok, _} = BankWorker.start_link(FakeBank)
      assert called :poolboy.transaction(:crawler_pool, :_)
      assert [buy_value: 63.4, sell_value: 64.4] = BankWorker.get_rate(FakeBank)
    end
  end

  test "load error" do
    response = %HTTPoison.Response{
      status_code: 404,
      body: "Not found"
    }

    with_mock :poolboy, [transaction: fn (:crawler_pool, _fake) -> {:ok, response} end] do
      {:ok, _} = BankWorker.start_link(FakeBank)
      assert called :poolboy.transaction(:crawler_pool, :_)
      assert [] = BankWorker.get_rate(FakeBank)
    end

    with_mock :poolboy, [transaction: fn (:crawler_pool, _fake) -> {:ok, response} end] do
      assert [] = BankWorker.get_rate(FakeBank)
      assert called :poolboy.transaction(:crawler_pool, :_)
    end
  end

  test "do not load rate on server call" do
    success_data = [
      buy_value: 63.4,
      sell_value: 64.4
    ]
    {:ok, json} = JSON.encode(success_data)

    response = %HTTPoison.Response{
      status_code: 200,
      body: json
    }

    with_mock :poolboy, [transaction: fn(:crawler_pool, _fake) -> {:ok, response} end] do
      {:ok, _} = BankWorker.start_link(FakeBank)
    end

    with_mock :poolboy, [transaction: fn(:crawler_pool, _fake) -> {:ok, response} end] do
      assert [buy_value: 63.4, sell_value: 64.4] = BankWorker.get_rate(FakeBank)
      assert not called :poolboy.transaction(:carwler_pool, :_)
    end
  end

  test "reload rate after 5minutes since last update success" do
    success_data = [
      buy_value: 63.4,
      sell_value: 64.4
    ]
    {:ok, json} = JSON.encode(success_data)

    response = %HTTPoison.Response{
      status_code: 200,
      body: json
    }

    with_mock :poolboy, [transaction: fn(:crawler_pool, _fake) -> {:ok, response} end] do
      {:ok, _} = BankWorker.start_link(FakeBank)
    end

    success_data = [
      buy_value: 64.4,
      sell_value: 65.4
    ]
    {:ok, json} = JSON.encode(success_data)

    response = %HTTPoison.Response{
      status_code: 200,
      body: json
    }

    now = Duration.now
    with_mocks([
      {:poolboy, [], [transaction: fn(:crawler_pool, _fake) -> {:ok, response} end]},
      {Duration, [], [diff: fn(_, _, :seconds) -> 301 end, now: fn -> now end]}
    ]) do
      assert [buy_value: 64.4, sell_value: 65.4] = BankWorker.get_rate(FakeBank)
      assert called :poolboy.transaction(:crawler_pool, :_)
    end
  end
end