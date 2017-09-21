defmodule PlumWeb.Api.LandView do
  use PlumWeb, :view
  @attributes ~w(city department lat lng price surface)a

  def render("index.json", %{lands: lands}) do
    render_many(lands, __MODULE__, "land.json")
  end

  def render("land.json", %{land: land}) do
    land |> Map.take(@attributes)
  end
end
