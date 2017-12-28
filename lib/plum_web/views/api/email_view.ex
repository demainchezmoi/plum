defmodule PlumWeb.Api.EmailView do
  use PlumWeb, :view

  alias PlumWeb.Api.{
    EmailView,
  }

  @attributes ~w(
    label
    value
  )a

  def render("index.json", %{emails: emails}) do
    %{data: render_many(emails, EmailView, "email.json")}
  end

  def render("show.json", %{email: email}) do
    %{data: render_one(email, EmailView, "email.json")}
  end

  def render("email.json", %{email: email}) do
    email
    |> Map.take(@attributes)
  end
end


