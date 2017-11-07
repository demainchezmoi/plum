# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Plum.Repo.insert!(%Plum.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

{:ok, land} = Plum.Sales.create_land(%{location: %{lat: 4.81, lng: 2.3}, description: "Beau terrain arboré de 1000 m² avec vue imprenable sur le vexin situé à lainville en vexin sur rue très calme. cos 0.2 et façade de 16m. beau potentiel, a voir rapidement avec l'adresse meulan.", images: ["https://s3-eu-west-1.amazonaws.com/demainchezmoi/cloudfront_assets/images/terrain.jpg"], city: "Blaru", department: "78", price: 39_800, surface: 421})

{:ok, ad} = Plum.Sales.create_ad(%{land_id: land.id})
