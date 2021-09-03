defmodule Usd2rur.CrawlerWorker do
  use GenServer
  require Logger

  # Pupic api

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def show_calls(pid) do
    GenServer.call(pid, :show_calls)
  end

  def crawl(pid, url) do
    GenServer.call(pid, {:crawl, url})
  end

  # Call handlers

  def init(:ok) do
    Logger.info "Start Crawler worker"
    {:ok, 0}
  end

  def handle_call(:show_calls, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:crawl, url}, _from, state) do
    Logger.info "Crawl #{url}"
    response = HTTPoison.get(url)
    {:reply, response, state + 1}
  end
end