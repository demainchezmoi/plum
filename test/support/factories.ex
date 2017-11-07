defmodule Plum.Factory do

  use ExMachina.Ecto, repo: Plum.Repo

  alias Plum.Sales.{
    Ad,
    Land,
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
      ads: [build(:ad)],
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

  def session_factory do
    %Session{
      token: sequence(:token, &"token_#{&1}")
    }
  end

  def user_factory do
    %User{
      first_name: "Polo",
      last_name: nil,
      admin: true,
      email: sequence(:email, &"hubert@bonnisseur#{&1}.com"),
      facebook_id: sequence(:facebook_id, &"fbid-#{&1}"),
      roles: [],
    }
  end
end
