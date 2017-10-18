defmodule PlumWeb.Api.LandView do
  use PlumWeb, :view
  @attributes ~w(id city department lat lng price surface description images)a

  def render("index.json", %{lands: lands}) do
    %{data: render_many(lands, __MODULE__, "land.json")}
  end

  def render("show.json", %{land: land}) do
    %{data: render_one(land, __MODULE__, "land.json")}
  end

  def render("land.json", %{land: land}) do
    land |> Map.take(@attributes)
  end
end
