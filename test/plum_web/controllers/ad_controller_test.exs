defmodule PlumWeb.AdControllerTest do
  use PlumWeb.ConnCase
  import Plum.Factory
  alias Plum.Sales
  alias Plum.Sales.Project
  alias Plum.Repo

  describe "public ad" do
    setup [:create_ad]

    test "shows add", %{conn: conn, ad: ad} do
      conn = get conn, ad_path(conn, :public, ad)
      assert html_response(conn, 200)
    end

    test "doesn't show deactivated add", %{conn: conn, ad: ad} do
      Plum.Sales.update_ad(ad, %{active: false})
      assert_error_sent 404, fn ->
        get conn, ad_path(conn, :public, ad)
      end
    end
  end

  describe "interested"do
    setup [:create_ad]

    test "interested sends 401 when not logged in", %{conn: conn, ad: ad} do
      conn = get conn, ad_path(conn, :interested, ad)
      assert redirected_to(conn) == page_path(conn, :login)
    end

    @tag :logged_in
    test "interested creates project for user if not exists", %{conn: conn, current_user: current_user, ad: ad} do
      path = ad_path(conn, :interested, ad)
      get conn, path 
      assert Sales.get_project_by!(%{user_id: current_user.id, ad_id: ad.id})
    end

    @tag :logged_in
    test "interested doesnt create project for user if already exists", %{conn: conn, current_user: current_user, ad: ad} do
      insert(:project, ad_id: ad.id, user_id: current_user.id)
      path = ad_path(conn, :interested, ad)
      get conn, path 
      assert Project |> Repo.get_by(%{ad_id: ad.id, user_id: current_user.id})
    end

    @tag :logged_in
    test "interested redirects to project path", %{conn: conn, current_user: current_user, ad: ad} do
      conn = get conn, ad_path(conn, :interested, ad.id)
      project = Sales.get_project_by!(%{user_id: current_user.id, ad_id: ad.id})
      assert redirected_to(conn) == page_path(conn, :prospect, ["projets", to_string(project.id)])
    end
  end

  defp create_ad(_) do
    land = insert(:land)
    ad = land.ad
    {:ok, ad: ad, land: land}
  end
end
