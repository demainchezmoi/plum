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
    get "/merci", PageController, :merci
    get "/confidentialité", PageController, :confidentialite

    resources "/ad", AdController
    resources "/contact", ContactController, only: [:create, :show]
  end
end
