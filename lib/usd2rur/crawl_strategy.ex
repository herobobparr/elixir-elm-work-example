defmodule Usd2rur.CrawlStrategy do
  @moduledoc false
  alias Usd2rur.CrawlStrategy.AlphaBank
  alias Usd2rur.CrawlStrategy.Sberbank
  alias Usd2rur.CrawlStrategy.Tinkoff

  defmacro __using__(_opts) do
    quote do
      alias Usd2rur.CrawlStrategy
      alias Usd2rur.CrawlStrategy.AlphaBank
      alias Usd2rur.CrawlStrategy.Sberbank
      alias Usd2rur.CrawlStrategy.Tinkoff
    end
  end

  def crawl_map do
    [AlphaBank, Sberbank, Tinkoff]
      |> Enum.reduce(%{}, fn strategy, acc -> Map.put(acc, apply(strategy, :slug, []), strategy) end)
  end
end