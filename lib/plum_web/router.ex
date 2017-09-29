defmodule PlumWeb.Router do
  use PlumWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :protected_api do
    plug :accepts, ["json"]
    plug PlumWeb.Plugs.TokenAuthorization
  end

  scope "/", PlumWeb do
    pipe_through :protected
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
    get "/merci", PageController, :merci
    get "/contact", PageController, :contact
    resources "/ads", AdController
    resources "/contacts", ContactController
    resources "/lands", LandController
    get "/maison-plus-terrain/:id", AdController, :public
  end
end
