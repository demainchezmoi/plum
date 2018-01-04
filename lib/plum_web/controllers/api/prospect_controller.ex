defmodule PlumWeb.Api.ProspectController do
  use PlumWeb, :controller
  alias Plum.Sales
  alias Plum.Sales.Prospect
  alias Plum.Geo

  action_fallback PlumWeb.FallbackController

  def index(conn, _params) do
    prospects = Sales.list_prospects()
    conn |> render("index.json", prospects: prospects)
  end

  def create(conn, %{"prospect" => prospect_params}) do
    with {:ok, %Prospect{} = prospect} <- Sales.create_prospect(prospect_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_prospect_path(conn, :show, prospect))
      |> render("show.json", prospect: prospect)
    end
  end

  def show(conn, %{"id" => id}) do
    prospect = Sales.get_prospect!(id)
    render(conn, "show.json", prospect: prospect)
  end

  def update(conn, %{"id" => id, "prospect" => prospect_params}) do
    prospect = Sales.get_prospect!(id)
    with {:ok, %Prospect{} = prospect} <- Sales.update_prospect(prospect, prospect_params) do
      render(conn, "show.json", prospect: prospect)
    end
  end

  def delete(conn, %{"id" => id}) do
    prospect = Sales.get_prospect!(id)
    with {:ok, %Prospect{}} <- Sales.delete_prospect(prospect) do
      conn |> render(PlumWeb.Api.SuccessView, "deleted.json")
    end
  end
end

