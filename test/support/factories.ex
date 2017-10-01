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
      active: true
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

  def project_factory do
    %Project{}
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
      roles: [],
    }
  end
end
