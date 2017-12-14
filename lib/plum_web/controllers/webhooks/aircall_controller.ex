defmodule PlumWeb.Webhooks.AircallController do
  use PlumWeb, :controller
  alias Plum.Aircall

  defp webhook_token, do: Application.get_env(:plum, :aircall_webhook_token)

  def handle_call(conn, params = %{"token" => token}) do
    ^token = webhook_token()
    Aircall.handle_webhook(params)
    conn |> send_resp(200, "OK")
  end
end
