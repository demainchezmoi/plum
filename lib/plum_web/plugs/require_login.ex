defmodule PlumWeb.Plugs.RequireLogin do
  import Plug.Conn
  import Phoenix.Controller
  alias Phoenix.Controller
  alias PlumWeb.Router.Helpers, as: Routes

  def init({type, roles}), do: {type, roles}

  def call(conn, {type, roles}) do
    if current_user = conn.assigns[:current_user] do
      if has_roles(current_user, roles) do
        conn
      else
        conn |> forbidden(type)
      end
    else
      conn |> unauthorized(type)
    end
  end

  defp has_roles(_user, []), do: true
  defp has_roles(user, roles), do: user.roles |> Enum.any?(& &1 in roles)

  defp forbidden(conn, :html) do
    conn
    |> put_status(:forbidden)
    |> render(PlumWeb.ErrorView, "403.html")
    |> halt
  end

  defp forbidden(conn, :json) do
    conn
    |> put_status(:forbidden)
    |> render(PlumWeb.Api.ErrorView, "403.json")
    |> halt
  end

  defp unauthorized(conn, :html) do
    conn
    |> redirect(to: Routes.page_path(conn, :login))
    |> halt()
  end

  defp unauthorized(conn, :json) do
    conn
    |> put_status(:unauthorized)
    |> render(PlumWeb.Api.ErrorView, "401.json")
    |> halt
  end
end
