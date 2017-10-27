defmodule PlumWeb.Email do
  use PlumWeb, :view
  use Smoothie,
    template_dir: Path.join(["..", "templates", "email"]),
    layout_file: Path.join(["..", "templates", "layout", "email.html.eex"])

  alias Plum.Accounts.User
  alias Plum.Sales.Project

  import Swoosh.Email

  def new_project_email(user = %User{}, project = %Project{}) do
    title = "Votre project maisons-leo.fr"
    project_href = page_url(PlumWeb.Endpoint, :prospect, ["projets", to_string(project.id)])
    assigns = [
      project: project,
      project_href: project_href,
      title: title,
      user: user,
    ]
    new()
    |> to(user.email)
    |> from({"Alexandre Hervé", "aherve@demainchezmoi.fr"})
    |> subject(title)
    |> html_body(new_project_html(assigns))
    |> text_body(new_project_text(assigns))
  end

  def welcome_email(user = %User{}) do
    title = "Bienvenue sur maisons-leo.fr"
    assigns = [
      user: user,
      title: title
    ]
    new()
    |> to(user.email)
    |> from({"Alexandre Hervé", "aherve@demainchezmoi.fr"})
    |> subject(title)
    |> html_body(welcome_html(assigns))
    |> text_body(welcome_text(assigns))
  end

  def contact_email(%{"email" => email}) do
    new()
    |> to("contact@demainchezmoi.fr")
    |> from({"Alexandre Hervé", "aherve@demainchezmoi.fr"})
    |> subject("Nouveau contact")
    |> html_body("<div>Nouveau contact : #{email}</div>")
    |> text_body("Nouveau contact : #{email}")
  end
end
