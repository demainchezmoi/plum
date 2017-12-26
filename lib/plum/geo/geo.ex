defmodule Plum.Geo do
  import Ecto.Query, warn: false

  alias Plum.Repo
  alias Plum.Geo.{City, Land, LandAd}
  alias Ecto.Changeset

  # ==============
  # City
  # ==============

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

  @doc """
  Finds a city with a similar name in the same department or returns nil.

  ## Examples

      iex> find_matching_city("Blaru", "78")
      %City{}

      iex> find_matching_city("Blaru", "72")
      nil
  """

  def find_matching_city(name, department) do
    query =
      from c in City,
      where: fragment("? LIKE '?%'", c.insee_id, ^department),
      where: fragment("? % ?", c.name, ^name),
      order_by: fragment("similarity(?, ?) DESC", c.name, ^name),
      limit: 1
    query |> Repo.one
  end

  # ==============
  # Land
  # ==============

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking land changes.

  ## Examples

      iex> change_land(land)
      %Ecto.Changeset{source: %Land{}}

  """
  def change_land(%Land{} = land) do
    Land.changeset(land, %{})
  end

  @doc """
  Creates a Land.

  ## Examples

      iex> create_land(%{field: value})
      {:ok, %Land{}}

      iex> create_land(%{field: value})
      {:error, %Ecto.Changeset{}}

  """
  def create_land(attrs \\ %{}) do
    %Land{}
    |> Land.changeset(attrs)
    |> Repo.insert()
  end

  def find_matching_land(params) do
    Land
    |> matching_price(params)
    |> matching_surface(params)
    |> matching_description(params)
    |> limit(1)
    |> Repo.one
  end

  defp matching_price(query, %{
    "price" => price
  }) when is_nil(price) or price == "", do: query
  defp matching_price(query, %{"price" => price}) do
    from l in query, where: l.price == ^price
  end
  defp matching_price(query, _), do: query


  defp matching_surface(query, %{
    "surface" => surface
  }) when is_nil(surface) or surface == "", do: query
  defp matching_surface(query, %{"surface" => surface}) do
    from l in query, where: l.surface == ^surface
  end
  defp matching_surface(query, _), do: query


  defp matching_description(query, %{
    "description" => description
  }) when is_nil(description) or description == "", do: query
  defp matching_description(query, %{"description" => description}) do
    from l in query,
      where: fragment("similarity(?, ?) > 0.4", ^description, l.description),
      order_by: [desc: fragment("similarity(?, ?)", ^description, l.description)]
  end
  defp matching_description(query, _), do: query

  # ==============
  # LandAd
  # ==============

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking land_ad changes.

  ## Examples

      iex> change_land_ad(land_ad)
      %Ecto.Changeset{source: %LandAd{}}

  """
  def change_land_ad(%LandAd{} = land_ad) do
    LandAd.changeset(land_ad, %{})
  end


  @doc """
  Gets a single ad by attributes.

  ## Examples

      iex> get_ad_by(%{param: value})
      %LandAd{}

      iex> get_ad_by(%{param: value})
      nil

  """
  def get_ad_by(params), do: Repo.get_by(LandAd, params)

  @doc """
  Creates a LandAd.

  ## Examples

      iex> create_land_ad(%{field: value})
      {:ok, %LandAd{}}

      iex> create_land_ad(%{field: value})
      {:error, %Ecto.Changeset{}}

  """
  def create_land_ad(attrs \\ %{}) do
    %Land{}
    |> Land.changeset(attrs)
    |> Repo.insert()
  end
end
