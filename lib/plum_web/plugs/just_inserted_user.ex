defmodule PlumWeb.Plugs.JustInsertedUser do
  import Plug.Conn
  require Logger

  def init(_), do: :ok

  def call(conn, _) do
    case conn |> get_session(:_plum_user_status) do
      :inserted ->
        Logger.info "Just insterted detected"
        conn
        |> assign(:user_just_inserted, true)
        |> put_session(:_plum_user_status, nil)

      e ->
        Logger.info "Just insterted NOT detected #{inspect e}"
        conn
    end
  end
end
