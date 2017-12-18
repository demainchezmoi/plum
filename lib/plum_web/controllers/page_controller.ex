defmodule PlumWeb.PageController do
  use PlumWeb, :controller
  alias Plum.Sales
  alias Plum.Repo

  plug PlumWeb.Plugs.JustInsertedUser when action in [:prospect]

  def index(conn, params) do
    conn |> render("index.html", params: params)
  end

  def merci(conn, _params) do
    conn |> render("merci.html")
  end

  def legal(conn, _params) do
    conn |> render("legal.html")
  end

  def confidentialite(conn, _params) do
    conn |> render("confidentialite.html")
  end

  def login(conn, _params) do
    conn |> render("login.html", query_params: conn.query_params)
  end

  def contact(conn, params = %{"contact" => contact_params}) do
    conn =
      if not is_undef(contact_params, "phone") do
        creation = NaiveDateTime.utc_now |> NaiveDateTime.to_iso8601
        Plum.Zapier.new_prospect(contact_params |> Map.put("creation", creation))
        conn |> put_flash(:info, "Votre demande a bien été prise en compte.")
      else
        conn |> put_flash(:error, "Merci de renseigner votre numéro de téléphone afin que nous puissions vous contacter.")
      end
    if not is_nil(ad = contact_params["ad"]) do
      ad = Sales.get_ad!(ad) |> Repo.preload(:land)
      conn |> redirect(to: ad_path(conn, :public, ad))
    else
      conn |> redirect(to: page_path(conn, :index))
    end
  end

  def is_undef(params, field), do: params[field] == "" or is_nil(params[field])
end
