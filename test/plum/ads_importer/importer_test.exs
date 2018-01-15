defmodule Plum.AdsImporter.ImporterTest do
  use Plum.DataCase
  import Plum.AdsImporter.Importer

  describe "import_ad" do
    test "rejects ads by constructor" do
      ad = %{"contact" => %{"name" => "TRECOBAT BRETAGNE"}}
      assert {:ok, :rejected_as_constructor} = import_ad(ad)
    end
  end
end
