defmodule Plum.Geo do
  import Ecto.Query, warn: false

  alias Plum.Repo
  alias Plum.Geo.City
  alias Ecto.Changeset

  @doc """
  Returns the list of city.

  ## Examples

      iex> list_cities()
      [%City{}, ...]

  """
  def list_cities do
    City
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  @doc """
  Gets a single city.

  Raises `Ecto.NoResultsError` if the City does not exist.

  ## Examples

      iex> get_city!(123)
      %City{}

      iex> get_city!(456)
      ** (Ecto.NoResultsError)

  """
  def get_city!(id), do: City |> Repo.get!(id)

  @doc """
  Gets a single city by attributes.

  Raises `Ecto.NoResultsError` if the City does not exist with those attributes.

  ## Examples

      iex> get_city_by!(%{id: 123, active: true})
      %City{}

      iex> get_city_by!(%{id: 123, active: false})
      ** (Ecto.NoResultsError)

  """
  def get_city_by!(params), do: Repo.get_by!(City, params)

  @doc """
  Gets a single city by attributes.

  ## Examples

      iex> get_city_by(%{id: 123, active: true})
      %City{}

      iex> get_city_by(%{id: 123, active: false})
      nil

  """
  def get_city_by(params), do: Repo.get_by(City, params)

  @doc """
  Creates a city.

  ## Examples

      iex> create_city(%{field: value})
      {:ok, %City{}}

      iex> create_city(%{field: bcity_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_city(attrs \\ %{}) do
    %City{}
    |> City.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a city.

  ## Examples

      iex> update_city(city, %{field: new_value})
      {:ok, %City{}}

      iex> update_city(city, %{field: bcity_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_city(%City{} = city, attrs) do
    city
    |> City.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a City.

  ## Examples

      iex> delete_city(city)
      {:ok, %City{}}

      iex> delete_city(city)
      {:error, %Ecto.Changeset{}}

  """
  def delete_city(%City{} = city) do
    Repo.delete(city)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking city changes.

  ## Examples

      iex> change_city(city)
      %Ecto.Changeset{source: %City{}}

  """
  def change_city(%City{} = city) do
    City.changeset(city, %{})
  end
end
