defmodule PlumWeb.Email do
  use PlumWeb, :view
  use Smoothie,
    template_dir: Path.join(["..", "templates", "email"]),
    layout_file: Path.join(["..", "templates", "layout", "email.html.eex"])

  alias Plum.Accounts.User

  import Swoosh.Email

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

  def contact_email(params) do
    new()
    |> to("contact@demainchezmoi.fr")
    |> from({"Alexandre Hervé", "aherve@demainchezmoi.fr"})
    |> subject("Nouveau contact")
    |> html_body("<div>Nouveau contact : #{params["first_name"]} #{params["last_name"]} - #{params["phone"]} - #{params["email"]} - ad #{params["ad"]}</div>")
    |> text_body("Nouveau contact : #{params["first_name"]} #{params["last_name"]} - #{params["phone"]} - #{params["email"]} - ad #{params["ad"]}")
  end
end
