defmodule PlumWeb.Api.ProjectController do
  use PlumWeb, :controller

  alias Plum.Sales
  alias Plum.Sales.Project

  action_fallback PlumWeb.FallbackController

  @updatable_fields ~w(
    discover_house
    discover_land
    house_color_1
    house_color_2
  )

  # def index(conn, _params) do
    # projects = Sales.list_projects()
    # render(conn, "index.json", projects: projects)
  # end

  # def create(conn, %{"project" => project_params}) do
    # with {:ok, %Project{} = project} <- Sales.create_project(project_params) do
      # conn
      # |> put_status(:created)
      # |> put_resp_header("location", api_project_path(conn, :show, project))
      # |> render("show.json", project: project)
    # end
  # end

  def show(conn, %{"id" => id}) do
    current_user = conn.assigns.current_user
    project =
      Sales.get_project_by!(%{id: id, user_id: current_user.id})
      |> Sales.set_project_steps
    render(conn, "show.json", project: project)
  end

  def update(conn, %{"id" => id, "project" => project_params}) do
    current_user = conn.assigns.current_user
    project = Sales.get_project_by!(%{id: id, user_id: current_user.id})
    authorized_params = project_params |> Map.take(@updatable_fields)

    with {:ok, %Project{} = project} <- Sales.update_project(project, authorized_params) do
      render(conn, "show.json", project: project |> Sales.set_project_steps)
    end
  end

  # def delete(conn, %{"id" => id}) do
    # project = Sales.get_project!(id)
    # with {:ok, %Project{}} <- Sales.delete_project(project) do
      # send_resp(conn, :no_content, "")
    # end
  # end
end
