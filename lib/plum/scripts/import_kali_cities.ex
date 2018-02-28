defmodule Plum.Scripts.ImportKaliCities do
  alias Geo.Point, as: GeoPoint
  alias Plum.Geo
  alias Plum.Geo.City
  alias ExAws.S3

  @departments ~w[
		01 02 03 04 05 06 07 08 09 10 11 12 13 14 15
		16 17 18 19 2A 2B 21 22 23 24 25 26 27 28 29
		30 31 32 33 34 35 36 37 38 39 40 41 42 43 44
		45 46 47 48 49 50 51 52 53 54 55 56 57 58 59
		60 61 62 63 64 65 66 67 68 69 70 71 72 73 74
		75 76 77 78 79 80 81 82 83 84 85 86 87 88 89
		90 91 92 93 94 95 971 972 973 974 975 976
  ]

  def run do
    @departments |> Enum.map(&handle_department/1)
  end

  def handle_department(department) do
    bucket = "demainchezmoi"
    object = "/cities/department_#{department}_cities.json"

    S3.get_object(bucket, object)
    |> ExAws.request!
    |> Map.get(:body)
    |> Poison.decode!
    |> Enum.map(&handle_city/1)
  end

  def handle_city(city_data) do
    case Geo.get_city_by(%{insee_id: city_data["insee_id"]}) do
      nil -> city_data |> format_city_data |> Geo.create_city
      city = %Geo.City{} -> Geo.update_city(city, format_city_data(city_data))
    end
  end

  def format_city_data(city_data) do
    city_data
    |> Map.put("name", Map.get(city_data, "city_name"))
    |> Map.put("department", Map.get(city_data, "department_number"))
    |> Map.put("location", formated_city_location(city_data))
  end

  def formated_city_location(%{"location" => %{"coordinates" => coordinates}}) when is_list(coordinates) do
    lng = coordinates |> Enum.at(0)
    lat = coordinates |> Enum.at(1)
    %GeoPoint{srid: 4326, coordinates: {lng, lat}}
  end
  def formated_city_location(_), do: nil
end
