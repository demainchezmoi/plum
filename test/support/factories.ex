defmodule Plum.Factory do
  use ExMachina.Ecto, repo: Plum.Repo

  alias Plum.Sales.{
    Ad,
    Contact,
    Land
  }

  def ad_factory do
    %Ad{
      active: true,
      contacts: [build(:contact)],
    }
  end

  def contact_factory do
    %Contact{
      name: "Noel Flantier",
      email: "noel@flantier.com",
      phone: "05 63 78 12 43",
    }
  end

  def land_factory do
    %Land{
      ad: build(:ad),
      city: "Blaru",
      department: "27",
      lat: 48.0123,
      lng: 2.1201,
      price: 42_000,
      surface: 396,
    }
  end
end
