defmodule PlumWeb.Api.ProspectLandController do
  use PlumWeb, :controller

  alias Plum.Sales

  def create(conn, params = %{
    "land_id" => land_id,
    "prospect_id" => prospect_id,
    "status" => status
  }) do
    params = %{
      land_id: land_id,
      prospect_id: prospect_id,
      status: status,
    }
    Sales.associate_prospect_land!(params)
    conn |> send_resp(200, %{} |> Poison.encode!)
  end
end
