defmodule PlumWeb.Api.ProspectLandControllerTest do
  alias Plum.Repo
  alias Plum.Sales.ProspectLand
  alias Plum.Geo.Land

  import Ecto.Query
  import Plum.Factory

  use PlumWeb.ConnCase

  describe "create" do
    setup [:create_prospect, :create_land]

    @tag :logged_in
    test "associate prospect and land", %{
      conn: conn,
      prospect: prospect,
      land: land
    } do
      params = %{"prospect_id" => prospect.id, "land_id" => land.id, "status" => "interesting"}
      post conn, api_prospect_land_path(conn, :create, params)
      ids = prospect |> Repo.preload(:lands) |> Map.get(:lands) |> Enum.map(& &1.id)
      assert land.id in ids
    end

    @tag :logged_in
    test "changes prospect and land association", %{
      conn: conn,
      prospect: prospect,
      land: land
    } do
      params = %{"prospect_id" => prospect.id, "land_id" => land.id}
      interesting_params = Map.put(params, "status", "interesting")
      rejected_params = Map.put(params, "status", "rejected")
      land_id = land.id

      preload_query =
        from l in Land,
        join: pl in ProspectLand,
        on: pl.land_id == ^land_id and pl.status == "rejected"

      %ProspectLand{}
      |> ProspectLand.changeset(interesting_params)
      |> Repo.insert!

      post conn, api_prospect_land_path(conn, :create, rejected_params)

      ids = prospect |> Repo.preload(lands: preload_query) |> Map.get(:lands) |> Enum.map(& &1.id)
      assert land.id in ids
    end
  end

  defp create_prospect(_) do
    prospect = insert(:prospect)
    {:ok, prospect: prospect}
  end

  defp create_land(_) do
    land = insert(:land)
    {:ok, land: land}
  end
end
