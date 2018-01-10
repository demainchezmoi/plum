defmodule Plum.Helpers.Geo do
  alias Ecto.Changeset
  alias Geo.Point

  @doc """
  Work with a model to translate lat lng virtual
  fields to a Geo.Point object and reciprocally.
  """
  def put_location(changeset = %Changeset{changes: %{lat: lat, lng: lng}}) when is_float(lat) and is_float(lng) do
    location = get_location(changeset.changes.lng, changeset.changes.lat)
    changeset |> Changeset.put_change(:location, location)
  end

  def put_location(changeset = %Changeset{changes: %{location: %Point{coordinates: {lng, lat}}}}) when is_float(lat) and is_float(lng) do
    changeset |> Changeset.put_change(:lat, lat) |> Changeset.put_change(:lng, lng)
  end

  def put_location(changeset = %Changeset{}), do: changeset

  @doc """
  Get a Geo.Point struct from a lng and a lat
  """
  def get_location(lng, lat) when is_float(lat) and is_float(lng) do
   %Point{coordinates: {lng, lat}, srid: 4326}
  end
  def get_location(_, _), do: nil

  @doc """
  Format a geo field to be rendered in a json view
  """
  def format_geo(struct, field) do
    case struct |> Map.get(field) do
      nil -> struct
      value -> struct |> Map.put(field, value |> Geo.JSON.encode)
    end
  end

  @google_geocoding_base "https://maps.googleapis.com/maps/api/geocode/json"

  @doc """
  Gets coordinates associated with an address from google api
  """
  def get_location(address) do
    if Application.get_env(:plum, :env) == "test" do
      mock_get_location(address)
    else
      do_get_location(address)
    end
  end

  def do_get_location(address) do
    with res <- address |> get_location_url |> HTTPoison.get,
         {:ok, %HTTPoison.Response{body: body}} <- res,
         {:ok, results} <- Poison.decode(body),
         %{"results" => [result|_]} <- results,
         %{"geometry" => geometry} <- result,
         %{"location" => %{"lat" => lat, "lng" => lng}} <- geometry
    do
      %Point{coordinates: {lng, lat}, srid: 4326}
    else
      _ -> nil
    end
  end

  def mock_get_location(_address) do
    if (Mix.env != :test) do
      throw "Warning: using mock outside test mode."
    else
      %Point{coordinates: {2.33826401958, 43.3003282686}, srid: 4326}
    end
  end

  defp get_location_url(address) do
    "#{@google_geocoding_base}?key=#{geocoding_api_key()}&address=#{URI.encode(address)}"
  end

  defp geocoding_api_key, do: Application.get_env(:plum, :geocoding_api_key)
end
