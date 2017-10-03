defmodule PlumWeb.Api.ProjectControllerTest do
  use PlumWeb.ConnCase

  import Plum.Factory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  # describe "index" do
    # test "lists all projects", %{conn: conn} do
      # conn = get conn, api_project_path(conn, :index)
      # assert json_response(conn, 200)["data"] == []
    # end
  # end

  describe "show" do
    @tag :logged_in
    test "shows a project I own", %{conn: conn, current_user: current_user} do
      ad = insert(:ad)
      project = insert(:project, ad_id: ad.id, user_id: current_user.id)
      conn = get conn, api_project_path(conn, :show, project)
      assert json_response(conn, 200)["data"]["id"] == project.id
    end

    @tag :logged_in
    test "doesn't show someone else's project", %{conn: conn} do
      ad = insert(:ad)
      user = insert(:user)
      project = insert(:project, ad_id: ad.id, user_id: user.id)
      assert_error_sent 404, fn ->
        get conn, api_project_path(conn, :show, project)
      end
    end

    @tag :logged_in
    test "preloads the ad and land", %{conn: conn, current_user: current_user} do
      land = insert(:land)
      ad = insert(:ad, land_id: land.id)
      project = insert(:project, ad_id: ad.id, user_id: current_user.id)
      conn = get conn, api_project_path(conn, :show, project)
      assert json_response(conn, 200)["data"]["ad"]["land"]["id"] == land.id
    end
  end

  # describe "create project" do
    # test "renders project when data is valid", %{conn: conn} do
      # conn = post conn, api_project_path(conn, :create), project: @create_attrs
      # assert %{"id" => id} = json_response(conn, 201)["data"]

      # conn = get conn, api_project_path(conn, :show, id)
      # assert json_response(conn, 200)["data"] == %{
        # "id" => id}
    # end

    # test "renders errors when data is invalid", %{conn: conn} do
      # conn = post conn, api_project_path(conn, :create), project: @invalid_attrs
      # assert json_response(conn, 422)["errors"] != %{}
    # end
  # end

  # describe "update project" do
    # setup [:create_project]

    # test "renders project when data is valid", %{conn: conn, project: %Project{id: id} = project} do
      # conn = put conn, api_project_path(conn, :update, project), project: @update_attrs
      # assert %{"id" => ^id} = json_response(conn, 200)["data"]

      # conn = get conn, api_project_path(conn, :show, id)
      # assert json_response(conn, 200)["data"] == %{
        # "id" => id}
    # end

    # test "renders errors when data is invalid", %{conn: conn, project: project} do
      # conn = put conn, api_project_path(conn, :update, project), project: @invalid_attrs
      # assert json_response(conn, 422)["errors"] != %{}
    # end
  # end

  # describe "delete project" do
    # setup [:create_project]

    # test "deletes chosen project", %{conn: conn, project: project} do
      # conn = delete conn, api_project_path(conn, :delete, project)
      # assert response(conn, 204)
      # assert_error_sent 404, fn ->
        # get conn, api_project_path(conn, :show, project)
      # end
    # end
  # end
end
