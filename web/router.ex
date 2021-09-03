defmodule Usd2rur.Router do
  use Usd2rur.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  pipeline :api_auth do
    plug Guardian.Plug.EnsureAuthenticated, handler: Usd2rur.AuthController
  end

  scope "/", Usd2rur do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
   scope "/api", Usd2rur do
     pipe_through :api

     scope "/auth" do
       post "/login", AuthController, :login
     end

     scope "/user" do
       post "/", UserController, :create
     end

     scope "/currency" do
       pipe_through :api_auth
       get "/", CurrencyController, :list
       get "/:bank", CurrencyController, :bank
     end
   end
end
