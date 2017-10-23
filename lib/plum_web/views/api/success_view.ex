defmodule PlumWeb.Api.SuccessView do
  use PlumWeb, :view

  def render("deleted.json", _assigns) do
    %{"deleted": true}
  end
end
