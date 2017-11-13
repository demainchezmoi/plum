defmodule PlumWeb.PingController do
  use PlumWeb, :controller

  def ping(conn, _params) do
    conn |> send_resp(200, "OK")
  end
end
