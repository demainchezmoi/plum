defmodule PlumWeb.Email do
  use Phoenix.Swoosh, view: PlumWeb.EmailView, layout: {PlumWeb.LayoutView, :email}
  alias Plum.Sales.{Ad, Contact}

  def new_contact(contact) do
    new
    |> to({"Contact", "contact@demainchezmoi.fr"})
    |> from({"Formulaire", "contact@demainchezmoi.fr"})
    |> subject("Nouveau formulaire soumis")
    |> render_body("new_contact.html", %{contact: contact})
  end
end
