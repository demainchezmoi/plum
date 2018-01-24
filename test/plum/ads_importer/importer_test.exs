defmodule Plum.AdsImporter.ImporterTest do
  use Plum.DataCase
  alias Plum.Geo.{Land, LandAd}
  import Plum.AdsImporter.Importer
  import Plum.Factory

  describe "import_ad" do
    test "rejects ads by constructor" do
      ad = %{"contact" => %{"name" => "TRECOBAT BRETAGNE"}, "link" => "abc"}
      assert {:ok, :rejected_as_constructor} = import_ad(ad)
    end

    test "creates new ad for existing land" do
      land = insert(:land)
      new_link = land.ads |> List.first |> Map.get(:link) |> (&"#{&1}-alt").()
      origin = "asdfasdfasdf,eoxk"
      ad = %{
        "origin" => origin,
        "link" => new_link,
        "price" => land.price,
        "surface" => land.surface,
        "description" => land.description
      }
      import_ad(ad)
      assert %LandAd{} = LandAd |> Repo.get_by(%{
        land_id: land.id,
        origin: origin,
        link: new_link,
      })
    end

    test "creates land along with ad" do
      city = insert(:city)
      origin = "asxxuw,./"
      link = "x[[]qqq.,;is"
      ad = %{
        "origin" => origin,
        "link" => link,
        "price" => 12345,
        "surface" => 54321,
        "description" => "description",
        "raw_city_name" => city.name,
        "raw_postal_code" => city.postal_code,
      }
      import_ad(ad)
      assert %LandAd{land: %Land{}} = LandAd |> Repo.get_by!(%{
        origin: origin,
        link: link
      }) |> Repo.preload(:land)
    end
  end
end
