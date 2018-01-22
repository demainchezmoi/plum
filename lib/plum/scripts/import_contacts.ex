defmodule Plum.Scripts.ImportContacts do
  require Logger

  alias Plum.Sales
  alias ExAws.S3

  @bucket "demainchezmoi"
  @aws_object_id "/base_de_contact.csv"
  @format ["Creation", "Status", "Source", "Ref", "Nom",
           "Telephone", "Email", "Annonce", "Suivi", "Message prospect"]

  defp mapping do
    %{
      "Source" => {:origin, &id/2},
      "Nom" => {:contact, &name/2},
      "Telephone" => {:contact, &phone/2},
      "Email" => {:contact, &email/2},
      "Status" => {:notes, &id/2},
      "Suivi" => {:notes, &add_notes/2},
    }
  end

  def run do
    Logger.info("Running import contacts script")
    case S3.get_object(@bucket, @aws_object_id) |> ExAws.request do
      {:ok, %{body: body}} ->
        stream =
          body
          |> String.split("\n", trim: true)
          |> CSV.decode()
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
    Sales.create_prospect(struct)
  end

  defp make_struct(line) do
    base_prospect = %{contact: %{}, status: "in_progress"}
    line |> Enum.with_index |> Enum.reduce(base_prospect, &aggregate/2)
  end

  defp aggregate(field, acc) do
    foreign_key = @format |> Enum.at(elem(field, 1))
    case mapping()[foreign_key] do
      nil -> acc
      {key, f} -> acc |> Map.put(key, f.(elem(field, 0), acc))
    end
  end

  defp id(d, _acc), do: d

  defp name(d, %{contact: contact}) do
    [first_name|rest] = d |> String.split(" ")
    last_name = rest |> Enum.join(" ")
    contact |> Map.put(:first_name, first_name) |> Map.put(:last_name, last_name)
  end

  defp phone(d, %{contact: contact}) do
    contact |> Map.put(:phone_numbers, [%{value: d, label: "Principal"}])
  end
  defp email(d, %{contact: contact}) do
    contact |> Map.put(:emails, [%{value: d, label: "Principal"}])
  end

  defp add_notes(d, acc = %{notes: notes}), do: notes <> "\n" <> d
end
