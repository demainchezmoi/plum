defmodule PlumWeb.Api.ProspectControllerTest do
  use PlumWeb.ConnCase
  import Plum.Factory
  alias Plum.Sales

  describe "index" do
    setup [:create_prospect]

    @tag :logged_in
    test "lists all prospects", %{conn: conn} do
      conn = get conn, api_prospect_path(conn, :index)
      assert json_response(conn, 200)
    end

    test "doesn't list all prospects when not logged in", %{conn: conn} do
      conn = get conn, api_prospect_path(conn, :index)
      assert json_response(conn, 401)
    end
  end


  describe "show prospect" do
    setup [:create_prospect]

    @tag :logged_in
    test "shows a prospect", %{conn: conn, prospect: prospect} do
      conn = get conn, api_prospect_path(conn, :show, prospect)
      assert json_response(conn, 200)["data"]["id"] == prospect.id
    end
  end

  describe "create prospect" do
    test "doesn't create prospect if not logged in", %{conn: conn} do
      prospect_attrs = params_for(:prospect)
      conn1 = post conn, api_prospect_path(conn, :create), prospect: prospect_attrs 
      assert json_response(conn1, 401)
      query_params =
        prospect_attrs |> Map.take([:max_budget])
      assert_raise Ecto.NoResultsError, fn -> Sales.get_prospect_by!(query_params) end
    end

    @tag :logged_in
    test "renders prospect when data is valid", %{conn: conn} do
      prospect_attrs = params_for(:prospect)
      conn1 = post conn, api_prospect_path(conn, :create), prospect: prospect_attrs 
      assert %{"id" => id} = json_response(conn1, 201) |> Map.get("data")

      conn2 = get conn, api_prospect_path(conn, :show, id)
      assert %{"id" => ^id} = json_response(conn2, 200)["data"]
    end

    @tag :logged_in
    test "creates todo along with prospect", %{conn: conn} do
      prospect_attrs = params_for(:prospect)
      conn1 = post conn, api_prospect_path(conn, :create), prospect: prospect_attrs 
      assert %{"id" => id} = json_response(conn1, 201) |> Map.get("data")

      conn2 = get conn, api_prospect_path(conn, :show, id)
      assert is_list(json_response(conn2, 200)["data"]["todos"])
    end

    @tag :logged_in
    test "renders errors when data is invalid", %{conn: conn} do
      prospect_attrs = params_for(:prospect) |> Map.put(:max_budget, "string")
      conn = post conn, api_prospect_path(conn, :create), prospect: prospect_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete prospect" do
    setup [:create_prospect]

    @tag :logged_in
    test "deletes prospect", %{conn: conn, prospect: prospect} do
      conn = delete conn, api_prospect_path(conn, :delete, prospect)
      assert json_response(conn, 200)
      assert_raise Ecto.NoResultsError, fn -> Sales.get_prospect!(prospect.id) end
    end

    test "doesnt delete prospect when not logged in", %{conn: conn, prospect: prospect} do
      conn = delete conn, api_prospect_path(conn, :delete, prospect)
      assert json_response(conn, 401)
      assert Sales.get_prospect!(prospect.id)
    end
  end

  defp create_prospect(_) do
    prospect = insert(:prospect)
    {:ok, prospect: prospect}
  end
end
