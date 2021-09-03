defmodule Usd2rur.CrawlStrategy.Tinkoff do
  @moduledoc """
  Contains info about url for requesting currency from AlfaBank and function that could parse it.
  """

  def name do
    "Tinkoff"
  end

  def slug do
    "tinkoff"
  end

  def url do
    "https://api.tinkoff.ru/v1/currency_rates"
  end

  def parse({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    with {:ok, %{"payload" => %{"rates" => rates}}} <- JSON.decode(body),
         {:ok, result_list} <- get_rate(rates) do
      {:ok, result_list}
    else
      {:ok, _} ->
        {:error, :wrong_json_structure, body}
      :not_found ->
        {:error, :wrong_json_structure, body}
      {:error, _} ->
        {:error, :cant_parse_json, body}
    end
  end

  def parse({:ok, response}) do
    {:error, :wrong_server_response, response}
  end

  def parse(_) do
    {:error, :server_request_error, "unexpected error"}
  end

  defp get_rate([head | tail]) do
    case head do
      %{
        "category" => "DebitCardsTransfers",
        "fromCurrency" => %{ "code" => 840 },
        "toCurrency" => %{ "code" => 643 },
        "buy" => buy_value,
        "sell" => sell_value
      } ->
        {:ok, [buy_value: buy_value, sell_value: sell_value]}
      _ ->
        get_rate(tail)
    end
  end

  defp get_rate([]) do
    :not_found
  end
end