defmodule PlumWeb.Api.ProjectViewTest do
  use PlumWeb.ConnCase, async: true

  alias PlumWeb.Api.{
    ProjectView,
    AdView,
  }

  import Plum.Factory

  test "renders preloaded ad" do
    ad = insert(:ad)
    user = insert(:user)
    project = insert(:project, ad: ad, user: user)
    rendered = ProjectView.render "project.json", %{project: project}
    ad_view = AdView.render "ad.json", %{ad: ad}
    assert rendered.ad == ad_view
  end
end

