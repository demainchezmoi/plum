defmodule PlumWeb.PageController do
  use PlumWeb, :controller
  alias PlumWeb.Email
  alias PlumWeb.Mailer
  alias Plum.Sales
  alias Plum.Repo

  plug PlumWeb.Plugs.JustInsertedUser when action in [:prospect]

  def index(conn, _params) do
    conn |> render("index.html")
  end

  def merci(conn, _params) do
    conn |> render("merci.html")
  end

  def confidentialite(conn, _params) do
    conn |> render("confidentialite.html")
  end

  def login(conn, _params) do
    conn |> render("login.html", query_params: conn.query_params)
  end

  def contact(conn, %{"contact" => contact_params}) do
    conn =
      if not (is_undef(contact_params, "email") and is_undef(contact_params, "phone")) do
        Email.contact_email(contact_params) |> Mailer.deliver
        HTTPoison.post "https://hooks.slack.com/services/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", Poison.encode! %{"text" => build_message(contact_params)}
        conn |> put_flash(:info, "Votre demande de contact a bien été prise en compte.")
      else
        conn |> put_flash(:error, "Merci de renseigner votre numéro de téléphone ou votre email pour prendre contact.")
      end
    if not is_nil(ad = contact_params["ad"]) do
      ad = Sales.get_ad!(ad) |> Repo.preload(:land)
      render conn, PlumWeb.AdView, "public.html", %{ad: ad}
    else
      conn |> render("index.html")
    end
  end

  def is_undef(params, field) do
    params[field] == "" or is_nil(params[field])
  end

  def build_message(params) do
    params
    |> Enum.map(fn
      {"ad", ad} -> "ad: " <> ad_url(PlumWeb.Endpoint, :public, ad)
      {k, v} -> k <> " : " <> v
    end)
    |> Enum.join("\n")
    |> (& "Un prospect a rempli un formulaire de contact :\n" <> &1).()
  end
end
