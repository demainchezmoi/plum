defmodule PlumWeb.Api.AdController do
  use PlumWeb, :controller
  alias Plum.Sales
  alias Plum.Sales.Ad

  action_fallback PlumWeb.FallbackController

  def index(conn, _params) do
    ads = Sales.list_ads()
    conn |> render("index.json", ads: ads)
  end

  def create(conn, %{"ad" => ad_params}) do
    with {:ok, %Ad{} = ad} <- Sales.create_ad(ad_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_ad_path(conn, :show, ad))
      |> render("show.json", ad: ad)
    end
  end

  def show(conn, %{"id" => id}) do
    current_user = conn.assigns.current_user
    ad = Sales.get_ad!(id)
    render(conn, "show.json", ad: ad)
  end
end

