defmodule Usd2rur.CurrencyControllerTest do
  use Usd2rur.ConnCase
  use Usd2rur.CrawlStrategy
  alias Usd2rur.BankWorker
  alias Usd2rur.Repo
  alias Usd2rur.User
  import Mock
  require Logger

  setup %{conn: conn} do
    changeset = User.changeset(
      %User{},
      %{
        "username" => "test",
        "password" => "asdf123",
        "password_confirmation" => "asdf123"
      }
    )
    {:ok, user} = Repo.insert(changeset)
    new_conn = Guardian.Plug.api_sign_in(conn, user)
    jwt = Guardian.Plug.current_token(new_conn)
    new_conn = new_conn
      |> put_req_header("auhtorization", "Bearer " <> jwt)

    {:ok, [conn: new_conn, unauth_conn: conn]}
  end


  describe "/api/currency" do
    test "return available list", %{conn: conn} do
        conn = get conn, "/api/currency"
        assert json_response(conn, 200)
    end
  end


  describe "/api/currency/alpha" do
    test "return rates", %{conn: conn} do
      with_mock BankWorker, [get_rate: fn AlphaBank -> [buy_value: 63.4, sellf_vaule: 64.4] end] do
        conn = get conn, "/api/currency/alpha"
        assert json_response(conn, 200)
      end
    end

    test "no rates", %{conn: conn} do
      with_mock BankWorker, [get_rate: fn AlphaBank -> [] end] do
        conn = get conn, "/api/currency/alpha"
        assert json_response(conn, 200)
      end
    end
  end

  describe "/api/currency/sberbank" do
    test "return rates", %{conn: conn} do
      with_mock BankWorker, [get_rate: fn Sberbank -> [buy_value: 63.4, sellf_vaule: 64.4] end] do
        conn = get conn, "/api/currency/sberbank"
        assert json_response(conn, 200)
      end
    end

    test "no rates", %{conn: conn} do
      with_mock BankWorker, [get_rate: fn Sberbank -> [] end] do
        conn = get conn, "/api/currency/sberbank"
        assert json_response(conn, 200)
      end
    end
  end

  describe "/api/currency/tinkoff" do
    test "return rates", %{conn: conn} do
      with_mock BankWorker, [get_rate: fn Tinkoff -> [buy_value: 63.4, sellf_vaule: 64.4] end] do
        conn = get conn, "/api/currency/tinkoff"
        assert json_response(conn, 200)
      end
    end

    test "no rates", %{conn: conn} do
      with_mock BankWorker, [get_rate: fn Tinkoff -> [] end] do
        conn = get conn, "/api/currency/tinkoff"
        assert json_response(conn, 200)
      end
    end
  end

  test "not found", %{conn: conn} do
    conn = get conn, "/api/currency/fake-bank"
    assert json_response(conn, 404)
  end

  test "not auth", %{unauth_conn: conn} do
    conn = get conn, "/api/currency/fake-bank"
    assert json_response(conn, 401)
  end
end