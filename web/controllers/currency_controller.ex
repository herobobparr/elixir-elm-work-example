defmodule Usd2rur.CurrencyController do
  use Usd2rur.Web, :controller
  alias Usd2rur.CrawlStrategy
  alias Usd2rur.BankWorker
  require Logger
  require Atom


  def list(conn, _) do
    bank_list = Map.values(crawl_list)
    render conn, "bank_list.json", %{bank_list: bank_list}
  end

  def bank(conn, %{"bank" => bank}) do
    Logger.info "Get data for #{bank} from on of #{inspect crawl_list}"
    case Map.fetch(crawl_list, bank) do
      {:ok, module} ->
        link = apply(module, :url, [])
        case BankWorker.get_rate(module) do
          [buy_value: buy_value, sell_value: sell_value] ->
            json conn, %{"buy" => buy_value, "sell": sell_value}
          _  ->
            Logger.error "Can`t get currency."
            conn
              |> put_status(200)
              |> json(%{})
        end
      :error ->
        Logger.error "Tried to access #{bank}"
        conn
          |> put_status(:not_found)
          |> json(%{"error": "Not found"})
    end
  end

  defp crawl_list do
    CrawlStrategy.crawl_map
  end
end