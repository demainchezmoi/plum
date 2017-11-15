defmodule Plum.Facebook do

  def me do
    Facebook.Graph.get("/me/accounts", "128372621147337|4iSIMF_RmO1ju_fhB5A6yv5wArc")
  end

  def app_access_token do
    Application.get_env(:plum, :facebook_client_id)
    <> "|"
    <> Application.get_env(:plum, :facebook_client_secret)
  end

  def get_long_lived_token(access_token) do

    url_base = "/oauth/access_token"

    params = %{
      "grant_type" => "fb_exchange_token",
      "client_id" => System.get_env("FACEBOOK_CLIENT_ID"),
      "client_secret" => System.get_env("FACEBOOK_CLIENT_SECRET"),
      "fb_exchange_token" => access_token
    } |> URI.encode_query

    Facebook.Graph.get(url_base, params)
  end

  def create_test_lead(access_token) do
    url =
      "#{548868212120683}/test_leads"

    params =
      %{"access_token" => access_token} |> URI.encode_query

    Facebook.Graph.post(url, params, [])
  end

  def read_test_lead(access_token) do
    url =
      "#{548868212120683}/test_leads"

    params =
      %{"access_token" => access_token} |> URI.encode_query

    Facebook.Graph.get(url, params)
  end
end
