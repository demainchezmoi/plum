defmodule PlumWeb.Api.ContactView do
  use PlumWeb, :view

  alias PlumWeb.Api.{
    ContactView,
    EmailView,
    PhoneNumberView,
  }

  import PlumWeb.ViewHelpers, only: [put_loaded_assoc: 2]

  @attributes ~w(
    first_name
    last_name
    origin
    type
    emails
    phone_numbers
  )a

  def render("index.json", %{contacts: contacts}) do
    %{data: render_many(contacts, ContactView, "contact.json")}
  end

  def render("show.json", %{contact: contact}) do
    %{data: render_one(contact, ContactView, "contact.json")}
  end

  def render("contact.json", %{contact: contact}) do
    contact
    |> Map.take(@attributes)
    |> put_loaded_assoc({:phone_numbers, PhoneNumberView, "index.json", :phone_numbers})
    |> put_loaded_assoc({:emails, EmailView, "index.json", :emails})
  end
end
