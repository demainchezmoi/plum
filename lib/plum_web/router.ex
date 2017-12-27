defmodule PlumWeb.Router do
  use PlumWeb, :router

  # ==========
  # Pipelines
  # ==========

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

  pipeline :api do
    plug :accepts, ["json"]
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

  pipeline :webhooks do
    plug :accepts, ["json"]
  end

  # ==========
  # Scopes
  # ==========

  # Browser
  scope "/", PlumWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/ping", PingController, :ping
    post "/contact", PageController, :contact
    get "/confidentialite", PageController, :confidentialite
    get "/login", PageController, :login
    get "/merci", PageController, :merci
    get "/mentions-legales", PageController, :legal
  end

  # Protected Browser
  scope "/", PlumWeb do
    pipe_through :protected_browser
  end

  # Admin Browser
  scope "/admin", PlumWeb do
    pipe_through :admin_browser
  end

  # Api
  scope "/api", PlumWeb.Api do
    pipe_through :api
    get "/signin/token/:token", AuthController, :show
    post "/signin/create", AuthController, :create
  end

  # Protected Api
  scope "/api", PlumWeb.Api do
    pipe_through :protected_api
    get "/ping", PingController, :ping
  end

  # Admin api
  scope "/api", PlumWeb.Api do
    pipe_through :admin_api
  end

  # Webhooks
  scope "/webhooks", PlumWeb.Webhooks do
    pipe_through :webhooks
    post "/aircall", AircallController, :handle_call
  end
end
