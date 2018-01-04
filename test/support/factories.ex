defmodule Plum.Factory do

  use ExMachina.Ecto, repo: Plum.Repo

  alias Plum.Sales.{
    Contact,
    ContactEmail,
    ContactPhone,
    EstateAgent,
    Prospect,
    ProspectLand,
  }

  alias Plum.Geo.{
    City,
    Land,
  }

  alias Plum.Accounts.{
    Session,
    User,
  }

  def city_factory do
    %City{
      name: sequence(:name, &"city name #{&1}"),
      insee_id: sequence(:insee_id, &"city insee_id #{&1}"),
      insee_id: sequence(:postal_code, &"city postal_code #{&1}"),
    }
  end

  def contact_factory do
    %Contact{
      first_name: "Marc",
      last_name: "Test",
      origin: "origin",
      emails: [build(:email)],
      phone_numbers: [build(:phone_number)],
      company: "Company"
    }
  end

  def email_factory do
    %ContactEmail{
      label: "Work",
      value: "test@lol.com"
    }
  end

  def estate_agent_factory do
    %EstateAgent{
      notes: "notes",
      contact: build(:contact),
      lands: [build(:land)],
    }
  end

  def land_factory do
    %Land{
      description: "desc",
      images: ["image"],
      notary_fees: 123,
      price: 123,
      surface: 123,
      address: "rue",
      land_register_ref: "lrr",
      serviced: false,
      slope: "weak",
      type: "tye",
      soc: 0.7,
      on_field_elements: "none",
      accessibility: "oui",
      sanitation: "non",
      environment: "arbre",
      geoportail: "www",
      googlemaps: "www",
      openstreetmaps: "www",
    }
  end

  def phone_number_factory do
    %ContactPhone{
      label: "Private",
      value: "+33666666666"
    }
  end

  def prospect_factory do
    %Prospect{
      contact: build(:contact),
      max_budget: 140_000
    }
  end

  def prospect_land_factory do
    %ProspectLand{
      status: "interesting"
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
