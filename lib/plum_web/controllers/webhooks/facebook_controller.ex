defmodule PlumWeb.Webhooks.FacebookController do
  use PlumWeb, :controller
  require Logger

  @base_leadgen_message "Un prospect a rempli un formulaire de contact :\n"

  def verify(conn, %{"hub.challenge" => challenge, "hub.verify_token" => token}) do
    ^token = "Ipe1HMNI4iRYVdJs7bGD2v3LbhNusPHPvy1qKRt1TyeIWKfzSff/AOFg84CAep17"
    conn |> send_resp(200, challenge)
  end

  defp handle_page_entry(%{"changes" => changes}) do
    changes |> Enum.map(&handle_page_change/1)
  end

  defp handle_page_change(%{"field" => "leadgen", "value" => %{"leadgen_id" => leadgen_id, "form_id" => form_id}}) do
    page_access_token = Application.get_env(:plum, :facebook_page_access_token)
    access_string = %{access_token: page_access_token} |> URI.encode_query

    {:json, form} = Facebook.Graph.get(form_id, access_string)
    {:json, leadgen} = Facebook.Graph.get(leadgen_id, access_string)

    @base_leadgen_message
    <> "formulaire : #{form["name"]}\n"
    <> build_leadgen_message(leadgen["field_data"])
    |> Plum.Slack.prospect_message
  end

  defp build_leadgen_message([], message), do: message

  defp build_leadgen_message([field|fields], message \\ "") do
    value = field["values"] |> Enum.join(" ")
    message <> "#{field["name"]} : #{value}\n"
  end

  defp handle_page_change(change) do
    Logger.warn("Unexpected facebook page change: #{inspect change}")
  end

  def notify(conn, %{"entry" => entry, "object" => "page"}) when is_list(entry) do
    entry |> Enum.map(&handle_page_entry/1)
    conn |> send_resp(200, "OK")
  end

  def notify(conn, params) do
    Logger.warn("Unexpected facebook notification: #{inspect params}")
    conn |> send_resp(404, "Not Found")
  end
end
