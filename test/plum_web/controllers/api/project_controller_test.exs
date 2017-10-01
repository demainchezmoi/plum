defmodule PlumWeb.Api.ProjectControllerTest do
  use PlumWeb.ConnCase

  import Plum.Factory

  def fixture(:project) do
    user = insert(:user)
    ad = insert(:ad)
    insert(:project, user_id: user.id, ad_id: ad.id)
  end

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
    setup [:create_project]

    @tag :logged_in
    test "shows a project", %{conn: conn, project: project} do
      conn = get conn, api_project_path(conn, :show, project)
      assert json_response(conn, 200)["data"]["id"] == project.id
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

  defp create_project(_) do
    project = fixture(:project)
    {:ok, project: project}
  end
end
