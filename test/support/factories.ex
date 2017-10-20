defmodule Plum.Factory do

  use ExMachina.Ecto, repo: Plum.Repo

  alias Plum.Sales.{
    Ad,
    Land,
    Project,
  }

  alias Plum.Accounts.{
    Session,
    User,
  }

  def ad_factory do
    %Ad{
      active: true,
      house_price: 89_000,
    }
  end

  def land_factory do
    %Land{
      ad: build(:ad),
      city: "Blaru",
      department: "27",
      location: %{lat: 48.01, lng: 2.12},
      price: 42_000,
      surface: 396,
      images: ["test"],
      description: sequence(:description, &"desc-#{&1}"),
      notary_fees: 1234
    }
  end

  def project_factory do
    %Project{
      discover_land: true,
      discover_house: false,
      contribution: 10_000,
      net_income: 1_800,
      phone_call: false,
      phone_number: "123456",
    }
  end

  def session_factory do
    %Session{
      token: sequence(:token, &"token_#{&1}")
    }
  end

  def user_factory do
    %User{
      admin: true,
      email: sequence(:email, &"hubert@bonnisseur#{&1}.com"),
      facebook_id: sequence(:facebook_id, &"fbid-#{&1}"),
      roles: [],
    }
  end
end
