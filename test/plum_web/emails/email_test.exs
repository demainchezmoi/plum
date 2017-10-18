defmodule PlumWeb.EmailTest do
  use PlumWeb.ConnCase
  import Plum.Factory
  alias PlumWeb.Email

  test "renders welcome email" do
    user = insert(:user)
    assert Email.welcome_email(user)
  end

  test "renders new_project email" do
    user = insert(:user)
    ad = insert(:ad, land: insert(:land))
    project = insert(:project, user: user, ad: ad)
    assert Email.new_project_email(user, project)
  end
end
