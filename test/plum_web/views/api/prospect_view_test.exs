defmodule PlumWeb.Api.ProspectViewTest do
  use Plum.DataCase, async: true

  alias PlumWeb.Api.{ProspectView, ContactView}

  import Plum.Factory

  test "prospect.json" do
    prospect = build(:prospect)
    rendered = ProspectView.render("prospect.json", %{prospect: prospect})
    assert rendered.id == prospect.id
    assert ContactView.render("contact.json", %{contact: prospect.contact}) == rendered.contact
  end
end
