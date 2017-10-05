defmodule PlumWeb.Api.ProjectView do
  use PlumWeb, :view
  alias PlumWeb.Api.{
    AdView,
    ProjectView,
  }
  import PlumWeb.ViewHelpers

  @attributes ~w(
    ad
    contribution
    discover_house
    discover_land
    house_color_1
    house_color_2
    id
    net_income
    phone_call
    steps
  )a

  def render("index.json", %{projects: projects}) do
    %{data: render_many(projects, ProjectView, "project.json")}
  end

  def render("show.json", %{project: project}) do
    %{data: render_one(project, ProjectView, "project.json")}
  end

  def render("project.json", %{project: project}) do
    project
    |> Map.take(@attributes)
    |> put_loaded_assoc({:ad, AdView, "ad.json", :ad})
  end
end
