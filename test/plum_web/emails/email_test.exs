defmodule PlumWeb.EmailTest do
  use PlumWeb.ConnCase
  import Plum.Factory
  alias PlumWeb.Email

  test "renders welcome email" do
    user = insert(:user)
    assert Email.welcome(user)
  end

  test "renders new_project email" do
    user = insert(:user)
    project = insert(:project)
    assert Email.new_project(user, project)
  end
end
