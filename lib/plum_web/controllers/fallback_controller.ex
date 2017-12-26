defmodule PlumWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use PlumWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(PlumWeb.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(PlumWeb.ErrorView, :"404")
  end

  def call(conn, {:error, status}) when status in ~w(forbidden invalid expired)a do
    conn
    |> put_status(:forbidden)
    |> render(PlumWeb.ErrorView, :"403")
  end
end
