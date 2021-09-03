defmodule Usd2rur.PageController do
  use Usd2rur.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
