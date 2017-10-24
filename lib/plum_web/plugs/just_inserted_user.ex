defmodule PlumWeb.Plugs.JustInsertedUser do
  import Plug.Conn

  def init(_), do: :ok

  def call(conn, _) do
    case conn |> get_session(:_plum_user_status) |> to_string do
      "inserted" ->
        conn
        |> assign(:user_just_inserted, true)
        |> put_session(:_plum_user_status, nil)

      _ ->
        conn
    end
  end
end
