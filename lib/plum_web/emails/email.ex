defmodule PlumWeb.Email do
  use PlumWeb, :view
  alias Plum.Accounts.User

  use Phoenix.Swoosh, view: PlumWeb.EmailView, layout: {PlumWeb.LayoutView, :email}

  def login_link(token_value, %User{email: email}) do
    new()
    |> to(email)
    |> from({"Alexandre Hervé", "aherve@demainchezmoi.fr"})
    |> subject("Votre lien de login")
    |> render_body("login_link.html", %{token: token_value})
  end
end
