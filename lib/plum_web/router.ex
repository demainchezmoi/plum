defmodule PlumWeb.Router do
  use PlumWeb, :router

  # Pipelines

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug PlumWeb.Plugs.Authentication
  end

  pipeline :protected_browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug PlumWeb.Plugs.Authentication
  end

  pipeline :protected_api do
    plug :accepts, ["json"]
    plug PlumWeb.Plugs.TokenAuthorization
  end


  # Scopes

  scope "/auth", PlumWeb do
    pipe_through :browser
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  scope "/", PlumWeb do
    pipe_through :protected_browser
    get "/admin*path", PageController, :admin
    get "/mon-espace*path", PageController, :prospect
  end

  scope "/api", PlumWeb.Api do
    pipe_through :protected_api
    resources "/lands", LandController, only: [:index], name: "api_land"
  end

  scope "/", PlumWeb do
    pipe_through :browser
    get "/", PageController, :index
    get "/technique", PageController, :technical
    get "/confidentialite", PageController, :confidentialite
    get "/login", PageController, :login
    get "/merci", PageController, :merci
    get "/contact", PageController, :contact
    resources "/ads", AdController
    resources "/contacts", ContactController
    resources "/lands", LandController
    get "/maison-plus-terrain/:id", AdController, :public
  end
end
