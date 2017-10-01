defmodule PlumWeb.Router do
  use PlumWeb, :router

  # Pipelines

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug PlumWeb.Plugs.SessionAuthentication
  end

  pipeline :protected_browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug PlumWeb.Plugs.SessionAuthentication
    plug PlumWeb.Plugs.RequireLogin, {:html, []}
  end

  pipeline :admin_browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug PlumWeb.Plugs.SessionAuthentication
    plug PlumWeb.Plugs.RequireLogin, {:html, ["admin"]}
  end

  pipeline :protected_api do
    plug :accepts, ["json"]
    plug PlumWeb.Plugs.TokenAuthentication
    plug PlumWeb.Plugs.RequireLogin, {:json, []}
  end

  pipeline :admin_api do
    plug :accepts, ["json"]
    plug PlumWeb.Plugs.TokenAuthentication
    plug PlumWeb.Plugs.RequireLogin, {:json, ["admin"]}
  end

  # Scopes

  scope "/auth", PlumWeb do
    pipe_through :browser
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  scope "/", PlumWeb do
    pipe_through :browser
    get "/", PageController, :index
    get "/technique", PageController, :technical
    get "/confidentialite", PageController, :confidentialite
    get "/login", PageController, :login
    get "/merci", PageController, :merci
    get "/contact", PageController, :contact
    resources "/contacts", ContactController, only: [:new, :create]
    # resources "/ads", AdController, only: [:public]
    # resources "/lands", LandController
    get "/maison-plus-terrain/:id", AdController, :public
  end

  scope "/", PlumWeb do
    pipe_through :protected_browser
    get "/mon-espace*path", PageController, :prospect
  end

  scope "/", PlumWeb do
    pipe_through :admin_browser
    get "/admin*path", PageController, :admin
  end

  scope "/api", PlumWeb.Api do
    pipe_through :admin_api
    resources "/lands", LandController, only: [:index], name: "api_land"
  end
end
