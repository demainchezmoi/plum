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
    post "/contact", PageController, :contact
    get "/confidentialite", PageController, :confidentialite
    get "/login", PageController, :login
    get "/merci", PageController, :merci
    get "/maison-plus-terrain/:id", AdController, :public
    get "/annonces-maison-plus-terrain", AdController, :public_index
    get "/maison-plus-terrain/:id/login", AdController, :login
    get "/maison-plus-terrain/:id/cgu", AdController, :cgu
  end

  scope "/", PlumWeb do
    pipe_through :protected_browser
    get "/mon-espace/*p", PageController, :prospect
    get "/ads/:id/interested", AdController, :interested
  end

  scope "/", PlumWeb do
    pipe_through :admin_browser
    get "/admin*path", PageController, :admin
  end

  scope "/api", PlumWeb.Api do
    pipe_through :protected_api
    resources "/projects", ProjectController, only: [:show, :update], name: "api_project"
  end

  scope "/api", PlumWeb.Api do
    pipe_through :admin_api
    resources "/lands", LandController, only: [:index, :create, :show, :update, :delete], name: "api_land"
    resources "/ads", AdController, only: [:index, :create, :show], name: "api_ad"
  end
end
