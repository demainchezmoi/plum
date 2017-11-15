defmodule PlumWeb.Webhooks.FacebookController do
  use PlumWeb, :controller
  require Logger

  def verify(conn, %{"hub.challenge" => challenge, "hub.verify_token" => token}) do
    ^token = "Ipe1HMNI4iRYVdJs7bGD2v3LbhNusPHPvy1qKRt1TyeIWKfzSff/AOFg84CAep17"
    conn |> send_resp(200, challenge)
  end

  def notify(conn, %{"entry" => entry, "object" => "page"}) when is_list(entry) do
    entry |> Enum.map(&handle_page_entry/1)
    conn |> send_resp(200, "OK")
  end

  defp handle_page_entry(%{"changes" => changes}) do
    changes |> Enum.map(&handle_page_change/1)
  end

  defp handle_page_change(%{"field" => "leadgen", "value" => value}) do
    HTTPoison.post "https://hooks.slack.com/services/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", Poison.encode!(%{"text" => inspect(value)})
  end

  defp handle_page_change(change) do
    Logger.warn("Unexpected facebook page change: #{inspect change}")
  end

  def notify(conn, params) do
    Logger.warn("Unexpected facebook notification: #{inspect params}")
    conn |> send_resp(404, "Not Found")
  end
end
