defmodule PlumWeb.Plugs.RequireLogin do

  import Plug.Conn
  import Phoenix.Controller, only: [redirect: 2]
  alias PlumWeb.Router.Helpers, as: Routes

  def init(_), do: :ok

  def call(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> redirect(to: Routes.page_path(conn, :login))
      |> halt()
    end
  end
end
