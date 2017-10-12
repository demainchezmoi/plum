defmodule PlumWeb.Email do

  alias Plum.Accounts.User
  alias Plum.Sales.Project
  import Swoosh.Email

  use Smoothie,
    template_dir: Path.join(["..", "templates", "email"]),
    layout_file: Path.join(["..", "templates", "layout", "email.html.eex"])

  def new_project_email(user = %User{}, project = %Project{}) do
    title = "Votre project maisons-leo.fr"
    assigns = [user: user, project: project, title: title]
    new()
    |> to(user.email)
    |> from({"Alexandre Hervé", "aherve@demainchezmoi.fr"})
    |> subject(title)
    |> html_body(new_project_html(assigns))
    |> text_body(new_project_text(assigns))
  end

  def welcome_email(user = %User{}) do
    title = "Bienvenue sur maisons-leo.fr"
    assigns = [user: user]
    new()
    |> to(user.email)
    |> from({"Alexandre Hervé", "aherve@demainchezmoi.fr"})
    |> subject(title)
    |> html_body(welcome_html(assigns))
    |> text_body(welcome_text(assigns))
  end
end
