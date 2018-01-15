defmodule Plum.AdsImporter.ImporterTest do
  use Plum.DataCase
  alias Plum.Geo.LandAd
  import Plum.AdsImporter.Importer
  import Plum.Factory

  describe "import_ad" do

    test "rejects ads by constructor" do
      ad = %{"contact" => %{"name" => "TRECOBAT BRETAGNE"}}
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
      ads_count = land.ads |> length
      import_ad(ad)
      assert %LandAd{} = LandAd |> Repo.get_by(%{
        land_id: land.id,
        origin: origin,
        link: new_link,
      })
    end
  end
end
