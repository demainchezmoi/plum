defmodule PlumWeb.Api.AuthView do
  use PlumWeb, :view

  def render("show.json", %{token: token}) do
    %{data: %{token: token}}
  end
end
