defmodule PlumWeb.Controllers.CityControllerTest do
  use PlumWeb.ConnCase
  import Plum.Factory

  describe "autocomplete" do
    @tag :logged_in
    test "returns cities", %{conn: conn} do
      insert(:city, name: "test")
      query_params = %{"search" => "test"}
      conn = get conn, api_city_path(conn, :autocomplete, query_params)
      assert json_response(conn, 200) |> inspect =~ "test"
    end
  end
end
