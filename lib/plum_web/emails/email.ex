defmodule PlumWeb.Email do

  alias Plum.Accounts.User
  alias Plum.Sales.Project

  use Phoenix.Swoosh, view: PlumWeb.EmailView, layout: {PlumWeb.LayoutView, :email}

  use Smoothie,
    template_dir: "",
    layout_file: Path.join(["..", "templates", "layout", "email.html.eex"])

  def welcome(user = %User{}) do
    new()
    |> to(user.email)
    |> from({"Alexandre Hervé", "aherve@demainchezmoi.fr"})
    |> subject("Bienvenue sur maisons-leo.fr")
    |> render_body("welcome.html")
  end

  def new_project(user = %User{}, project = %Project{}) do
    new()
    |> to(user.email)
    |> from({"Alexandre Hervé", "aherve@demainchezmoi.fr"})
    |> subject("Votre projet sur maisons-leo.fr")
    |> render_body("new_project.html")
  end
end
