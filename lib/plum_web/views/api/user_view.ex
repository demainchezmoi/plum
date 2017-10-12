defmodule PlumWeb.Api.UserView do
  use PlumWeb, :view
  alias PlumWeb.Api.{
    UserView
  }
  import PlumWeb.ViewHelpers

  @attributes ~w(
    id
  )a

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    user
    |> Map.take(@attributes)
  end
end


