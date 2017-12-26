defmodule PlumWeb.Api.PingController do
  use PlumWeb, :controller

  action_fallback PlumWeb.FallbackController

  def ping(conn, _params) do
    conn |> send_resp(200, Poison.encode!(%{data: %{ping: "pong"}}))
  end
end
