defmodule Plum.Factory do

  use ExMachina.Ecto, repo: Plum.Repo

  alias Plum.Sales.{
  }

  alias Plum.Accounts.{
    Session,
    User,
  }

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
