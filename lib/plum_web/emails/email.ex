defmodule PlumWeb.Email do
  use Phoenix.Swoosh, view: PlumWeb.EmailView, layout: {PlumWeb.LayoutView, :email}

  def welcome(user) do
    new
    |> to(user.email)
    |> from({"Alexandre Hervé", "aherve@demainchezmoi.fr"})
    |> subject("Bienvenue sur maisons-leo.fr")
    |> render_body("welcome.html")
  end
end
