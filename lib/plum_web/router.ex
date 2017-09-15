defmodule PlumWeb.Router do
  use PlumWeb, :router
  use Coherence.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session
  end

  pipeline :protected do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session, protected: true
  end

  scope "/" do
    pipe_through :browser
    coherence_routes()
  end

  scope "/" do
    pipe_through :protected
    coherence_routes :protected
  end

  scope "/", PlumWeb do
    pipe_through :browser
  end

  scope "/", PlumWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/confidentialité", PageController, :confidentialite
    get "/merci", PageController, :merci

    resources "/ads", AdController, only: [:show]
    resources "/contacts", ContactController, only: [:new, :create]
  end

  scope "/", PlumWeb do
    pipe_through :protected

    resources "/ads", AdController, except: [:show]
    resources "/contacts", ContactController, except: [:new, :create]
    resources "/lands", LandController
  end

end
