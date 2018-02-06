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

    test "replaces ad with same origin for existing land" do
      land = insert(:land)
      ad = land.ads |> List.first
      new_link = ad |> Map.get(:link) |> (&"#{&1}-alt").()
      origin = ad.origin
      crawled_ad = %{
        "origin" => origin,
        "link" => new_link,
        "price" => land.price,
        "surface" => land.surface,
        "description" => land.description
      }
      import_ad(crawled_ad)
      assert %LandAd{} = LandAd |> Repo.get_by(%{
        land_id: land.id,
        origin: origin,
        link: new_link,
      })
      assert is_nil(LandAd |> Repo.get_by(%{
        land_id: land.id,
        origin: origin,
        link: ad.link,
      }))
    end

    # test "associates ads replace association" do
      # city = insert(:city)
      # land = insert(:land, ads: [build(:land_ad), build(:land_ad)], city: city)

      # ads = land |> Repo.preload(:ads, force: true) |> Map.get(:ads)
      # ad_ids_init = ads |> Enum.map(& &1.id)

      # ad1 = ads |> Enum.at(0)
      # ad2 = ads |> Enum.at(1)

      # assert length(ads) == 2

      # ad_changes = [%LandAd{} |> LandAd.changeset(params_for(:land_ad)) | ad1]

      # land =
        # land
        # |> Land.changeset(%{})
        # |> Ecto.Changeset.put_assoc(:ads, ad_changes)
        # |> Repo.update!

      # ads_new = land |> Repo.preload(:ads, force: true) |> Map.get(:ads)
      # ad_ids_new = ads_new |> Enum.map(& &1.id)

      # assert length(ads_new) == 2
      # assert ad1.id in ad_ids_new
      # refute ad2.id in ad_ids_new
    # end

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
