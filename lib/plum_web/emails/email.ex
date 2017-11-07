defmodule PlumWeb.Email do
  use PlumWeb, :view
  alias Plum.Accounts.User

  use Phoenix.Swoosh, view: Sample.EmailView, layout: {PlumWeb.LayoutView, :email}

  def welcome_email(user = %User{}) do
    title = "Bienvenue sur maisons-leo.fr"
    new()
    |> to(user.email)
    |> from({"Alexandre Hervé", "aherve@demainchezmoi.fr"})
    |> subject(title)
    |> render_body("welcome.html", %{title: title})
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
