defmodule Plum.Scripts.ImportCities do

  require Logger

  alias Geo.Point
  alias Plum.Geo
  alias ExAws.S3

  @bucket "demainchezmoi"
  @aws_object_id "/laposte_hexasmal.csv"

  @format ["Code_commune_INSEE", "Nom_commune", "Code_postal",
           "Libelle_acheminement", "Ligne_5", "coordonnees_gps"]

  defp mapping do
    %{
      "Code_commune_INSEE" => {:insee_id, &id/2},
      "Nom_commune" => {:name, &id/2},
      "Code_postal" => {:postal_code, &id/2},
      "coordonnees_gps" => {:location, &location/2},
    }
  end

  def run do
    Logger.info("Running import cities script")
    case S3.get_object(@bucket, @aws_object_id) |> ExAws.request do
      {:ok, %{body: body}} ->
        stream =
          body
          |> String.split("\n", trim: true)
          |> CSV.decode(separator: ?;)
          header = stream |> Stream.take(1) |> Enum.to_list |> Enum.at(0)
          if header == @format do
            stream
            |> Stream.drop(1)
            |> Enum.map(&make_struct/1)
            |> Enum.map(&insert/1)
          else
            raise "Format inconnu"
          end
      err -> raise inspect(err)
    end
  end

  defp insert(struct) do
    case Geo.get_city_by(%{insee_id: struct.insee_id}) do
      nil -> Geo.create_city(struct)
      city = %Geo.City{} -> Geo.update_city(city, struct)
    end
  end

  defp make_struct(line) do
    line
    |> Enum.with_index
    |> Enum.reduce(%{}, &aggregate/2)
  end

  defp aggregate(field, acc) do
    foreign_key = @format |> Enum.at(elem(field, 1))
    case mapping()[foreign_key] do
      nil -> acc
      {key, f} -> acc |> Map.put(key, f.(elem(field, 0), acc))
    end
  end

  defp id(d, _acc), do: d

  defp location(d, _acc) do
    d |> String.split(", ") |> case do
      [lat, lng] -> %Point{coordinates: {lng, lat}, srid: 4326}
      _ -> nil
    end
  end
end
