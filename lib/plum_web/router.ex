defmodule PlumWeb.Router do
  use PlumWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PlumWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/confidentialité", PageController, :confidentialite
    get "/merci", PageController, :merci

    resources "/ads", AdController
    resources "/contacts", ContactController, only: [:create, :show, :new]
    resources "/lands", LandController
  end
end
