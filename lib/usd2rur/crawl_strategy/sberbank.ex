defmodule Usd2rur.CrawlStrategy.Sberbank do
  @docmodule """
  Contains info about url for requesting currency from AlfaBank and function that could parse it.
  """

  @type name :: bitstring
  def name do
    "Sberbank"
  end

  @type slug :: bitstring
  def slug do
    "sberbank"
  end

  @type url :: bitstring
  def url do
    "http://www.sberbank.ru/portalserver/proxy/?pipe=shortCachePipe&url=http%3A%2F%2Flocalhost%2Fsbt-services%2Fservices%2Frest%2FrateService%2Frate%2Fcurrent%3FcurrencyCode%3D840%26rateCategory%3Dbeznal%26regionId%3D2"
  end

  def parse({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    case JSON.decode(body) do
      {:ok, %{
        "beznal" => %{
          "840" => %{
            "0" => %{
              "buyValue" => buy_value,
              "sellValue" => sell_value
            }
          }
        }
      }} ->
        {:ok, [buy_value: buy_value, sell_value: sell_value]}
      {:ok, _} ->
        {:error, :wrong_json_structure, body}
      _ ->
        {:error, :cant_parse_json, body}
    end
  end

  def parse({:ok, response}) do
    {:error, :wrong_server_response, response}
  end

  def parse(_) do
    {:error, :server_request_error, "unexpected error"}
  end
end