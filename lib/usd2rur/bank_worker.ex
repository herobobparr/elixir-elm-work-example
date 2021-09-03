defmodule Usd2rur.BankWorker do
  use GenServer
  use Timex
  require Logger
  alias Usd2rur.CrawlerWorker

  @refresh_duration 300

  def start_link(crawler_module) do
    name = apply(crawler_module, :name, []) |> worker_name
    Logger.info "Start #{name}"
    GenServer.start_link(__MODULE__, %{crawler_module: crawler_module, rate: []}, [name: name])
  end

  def get_rate(crawler_module) do
    name = apply(crawler_module, :name, []) |> worker_name
    GenServer.call(name, :rate)
  end

  def init(state) do
    {:ok, update_rate(state)}
  end

  def handle_call(:rate, _from, state) do
    with {:ok, rate} <- Map.fetch(state, :rate),
         {:ok, updated_time} <- Map.fetch(state, :updated_time),
         true <- Duration.diff(Duration.now, updated_time, :seconds) < @refresh_duration do
      {:reply, rate, state}
    else
      _ ->
        state = update_rate(state)
        %{rate: rate} = state
        {:reply, rate, state}
    end
  end

  defp worker_name(name) do
    :"#{name}BankWorker"
  end

  defp load_rate(crawler_module) do
    link = apply(crawler_module, :url, [])

    response_data = Task.Supervisor.async(
      Usd2rur.TaskSupervisor,
      fn ->
        :poolboy.transaction(
          :crawler_pool,
          fn pid -> CrawlerWorker.crawl(pid, link) end
        )
      end
    )
      |> Task.await()

    case apply(crawler_module, :parse, [response_data]) do
      {:ok, values} ->
        {:ok, values}
      _ -> :error
    end
  end

  defp update_rate(state) do
    %{crawler_module: crawler_module} = state
    case load_rate(crawler_module) do
      {:ok, values} ->
        state
          |> Map.put(:rate, values)
          |> Map.put(:updated_time, Duration.now)
      _ -> state
    end
  end
end