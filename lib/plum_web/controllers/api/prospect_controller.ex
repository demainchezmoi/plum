defmodule PlumWeb.Api.ProspectController do
  use PlumWeb, :controller
  alias Plum.Repo
  alias Plum.Sales
  alias Plum.Sales.Prospect

  action_fallback PlumWeb.FallbackController

  def index(conn, params) do
    prospects_query = Sales.list_prospects_query(params)
    page = prospects_query |> Repo.paginate(params)

    render conn, "index.json",
      prospects: page.entries,
      page_number: page.page_number,
      total_pages: page.total_pages
  end

  def create(conn, %{"prospect" => prospect_params}) do
    params = prospect_params |> Map.put("to_be_called", true)
    with {:ok, %Prospect{} = prospect} <- Sales.create_prospect(params) do
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

