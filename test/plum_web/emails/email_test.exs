defmodule PlumWeb.EmailTest do
  use PlumWeb.ConnCase
  import Plum.Factory
  alias PlumWeb.Email

  test "renders welcome email" do
    user = insert(:user)
    assert Email.welcome_email(user)
  end

end
