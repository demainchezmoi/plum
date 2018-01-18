defmodule Plum.Sales.ContactTest do
  alias Ecto.Changeset
  alias Plum.Repo
  alias Plum.Sales.Contact
  import Plum.Factory
  use Plum.DataCase

  test "changeset sets emails from virtual" do
    params = params_for(:contact, emails: nil, email: "testemail")
    contact = %Contact{} |> Contact.changeset(params) |> Repo.insert!
    assert contact.emails |> List.first |> Map.get(:value) == "testemail"
  end

  test "changeset sets phone_numbers from virutal" do
    params = params_for(:contact, phone_numbers: nil, phone_number: "testphonenumber")
    contact = %Contact{} |> Contact.changeset(params) |> Repo.insert!
    assert contact.phone_numbers |> List.first |> Map.get(:value) == "testphonenumber"
  end

  test "changeset sets first and last name from name" do
    params = params_for(:contact, first_name: nil, last_name: nil, name: "Jean Paul")
    contact = %Contact{} |> Contact.changeset(params) |> Repo.insert!
    assert "Jean" = contact.first_name
    assert "Paul" = contact.last_name
  end
end
