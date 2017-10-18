defmodule PlumWeb.AdControllerTest do
  use PlumWeb.ConnCase

  import Plum.Factory
  import Swoosh.TestAssertions
  import Ecto.Query

  alias Plum.Repo
  alias Plum.Sales
  alias Plum.Sales.Project
  alias PlumWeb.Email

  describe "public ad" do
    setup [:create_ad]

    test "shows add", %{conn: conn, ad: ad} do
      conn = get conn, ad_path(conn, :public, ad)
      assert html_response(conn, 200)
    end

    test "doesn't show deactivated add", %{conn: conn, ad: ad} do
      Plum.Sales.update_ad(ad, %{active: false})
      conn = get conn, ad_path(conn, :public, ad)
      res = html_response(conn, 200)
      assert res |> String.downcase =~ ~S(class="deactivated-ad") 
    end
  end

  describe "interested"do
    setup [:create_ad]

    test "sends 401 when not logged in", %{conn: conn, ad: ad} do
      conn = get conn, ad_path(conn, :interested, ad)
      assert redirected_to(conn) == page_path(conn, :login, %{redirect: ad_path(conn, :interested, ad)})
    end

    @tag :logged_in
    test "creates project for user if it doesnt exist", %{conn: conn, current_user: current_user, ad: ad} do
      path = ad_path(conn, :interested, ad)
      conn = get conn, path
      assert project = Sales.get_project_by!(%{user_id: current_user.id, ad_id: ad.id})
      assert_email_sent Email.new_project_email(current_user, project)
    end

    @tag :logged_in
    test "doesn't create project for deactivated ad", %{conn: conn, current_user: current_user, ad: ad} do
      Plum.Sales.update_ad(ad, %{active: false})
      assert_error_sent 404, fn -> get conn, ad_path(conn, :interested, ad) end
      assert_raise Ecto.NoResultsError, fn -> Sales.get_project_by!(%{user_id: current_user.id, ad_id: ad.id}) end
    end

    @tag :logged_in
    test "doesnt create project for user if already exists", %{conn: conn, current_user: current_user, ad: ad} do
      insert(:project, ad_id: ad.id, user_id: current_user.id)
      path = ad_path(conn, :interested, ad)
      get conn, path
      assert project = Project |> preload([ad: :land])|> Repo.get_by(%{ad_id: ad.id, user_id: current_user.id})
      assert_email_not_sent Email.new_project_email(current_user, project)
    end

    @tag :logged_in
    test "redirects to project path", %{conn: conn, current_user: current_user, ad: ad} do
      conn = get conn, ad_path(conn, :interested, ad.id)
      project = Sales.get_project_by!(%{user_id: current_user.id, ad_id: ad.id})
      assert redirected_to(conn) == page_path(conn, :prospect, ["projets", to_string(project.id), "bienvenue"])
    end
  end

  defp create_ad(_) do
    land = insert(:land)
    ad = land.ad
    {:ok, ad: ad, land: land}
  end
end
