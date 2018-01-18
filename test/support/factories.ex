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
    LandAd,
    LandAdContact,
  }

  alias Plum.Accounts.{
    Session,
    User,
  }

  def city_factory do
    %City{
      name: sequence(:name, &"city name #{&1}"),
      insee_id: sequence(:insee_id, &"#{&1}"),
      postal_code: sequence(:postal_code, &"#{&1}"),
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
      accessibility: "oui",
      address: "rue",
      description: "desc",
      environment: "arbre",
      geoportail: "www",
      googlemaps: "www",
      images: ["image"],
      land_register_ref: "lrr",
      lat: 44.03,
      lng: 2.01,
      notary_fees: 123,
      on_field_elements: "none",
      openstreetmaps: "www",
      price: 123,
      sanitation: "non",
      serviced: false,
      slope: "weak",
      soc: 0.7,
      surface: 123,
      type: "tye",
      ads: [build(:land_ad)],
    }
  end

  def land_ad_factory do
    %LandAd {
      link: sequence(:link, &"link-#{&1}"),
      origin: sequence(:origin, &"origin-#{&1}"),
      contact: build(:land_ad_contact),
    }
  end

  def land_ad_contact_factory do
    %LandAdContact{
      address: "address"
    }
  end

  def point_factory do
    %Geo.Point{
      coordinates: {2.33826401958, 43.3003282686},
      srid: 4326
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
      max_budget: 140_000,
      status: "new",
    }
  end

  def prospect_land_factory do
    %ProspectLand{
      status: "selected"
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
