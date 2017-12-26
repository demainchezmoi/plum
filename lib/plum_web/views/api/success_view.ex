defmodule PlumWeb.Api.SuccessView do
  use PlumWeb, :view

  def render("deleted.json", _assigns) do
    %{"deleted": true}
  end

  def render("200.json", _assigns) do
    %{status: "Ok"}
  end
end
