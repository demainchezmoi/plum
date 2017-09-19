defmodule PlumWeb.EmailTest do
  use ExUnit.Case, async: true
  import Plum.Factory
  alias PlumWeb.Email

  describe "new_contact email" do
    test "builds email" do
      land = build(:land)
      ad = build(:ad, land: land) |> Map.put(:id, 12)
      contact = build(:contact, ad: ad)
      assert %Swoosh.Email{} = Email.new_contact(contact)
    end
  end
end
