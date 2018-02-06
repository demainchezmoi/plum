defmodule Plum.Geo do
  import Ecto.Query, warn: false

  alias Plum.Repo
  alias Plum.Geo.{City, Land, LandAd}

  require Logger

  # ==============
  # City
  # ==============

  @doc """
  Finds a list of cities matching a string

  ## Examples

      iex> cities_autocomplete("Abe")
      [%City{}, ...]
  """
  def cities_autocomplete(s) do
    query =
      from c in City,
      where: fragment("(unaccent(?) % unaccent(?)) OR (? % ?)", c.name, ^s, c.postal_code, ^s),
      order_by: [desc: fragment("greatest(similarity(unaccent(?), unaccent(?)), similarity(?, ?))", c.name, ^s, c.postal_code, ^s)],
      select: map(c, [:id, :postal_code, :name]),
      limit: 15

    query |> Repo.all
  end

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

  def find_matching_city(name, department) when is_binary(name) and is_binary(department) do
    Logger.debug("Find matching city for #{name} and #{department}")
    dep_short = department |> String.slice(0..1)

    query =
      from c in City,
      where: fragment("? LIKE ? || '%'", c.postal_code, ^dep_short),
      where: fragment("unaccent(?) % unaccent(?)", c.name, ^name),
      order_by: fragment("similarity(unaccent(?), unaccent(?)) DESC", c.name, ^name),
      limit: 1

    city = query |> Repo.one

    Logger.debug("Found city #{inspect city}")
    city
  end
  def find_matching_city(_, _), do: nil

  # ==============
  # Land
  # ==============
  @doc """
  Buids a query to fetch a list of lands with filters
  """

  def list_lands_query(params \\ %{}) do
    query =
      from l in Land,
      join: c in assoc(l, :city),
      preload: [:city, :ads, [estate_agent: :contact]],
      order_by: [desc: :inserted_at]

    query
    |> for_max_price(params)
    |> for_prospect(params)
    # |> for_max_surface(params)
    # |> for_min_price(params)
    # |> for_min_surface(params)
    |> for_cities(params)
    |> for_origin(params)
  end


  @doc """
  Returns the list of lands.

  ## Examples

      iex> list_lands()
      [%Land{}, ...]

  """
  def list_lands(params \\ %{}) do
    list_lands_query(params) |> Repo.all
  end

  def for_prospect(query, %{"prospect" => prospect_id, "pl_status" => status}) do
    from l in query,
      join: pl in assoc(l, :prospects_lands),
      on: pl.prospect_id == ^prospect_id and pl.status == ^status
  end

  def for_prospect(query, %{"prospect" => prospect_id}) do
    from l in query,
      left_join: pl in assoc(l, :prospects_lands),
      on: pl.prospect_id == ^prospect_id,
      where: is_nil(pl.id)
  end

  def for_prospect(query, _), do: query

  def for_origin(query, %{"origin" => origin}) do
    from l in query,
      join: a in assoc(l, :ads),
      where: a.origin == ^origin
  end
  def for_origin(query, _), do: query

  def for_cities(query, %{"cities" => cities}) when is_list(cities) do
    cities = cities |> Enum.map(&String.to_integer/1)
    from l in query,
      join: c in assoc(l, :city),
      where: l.city_id in ^cities
  end

  def for_cities(query, params = %{"cities" => cities}), do: for_cities(query, Map.put(params, "cities", [cities]))

  def for_cities(query, _), do: query

  def for_max_price(query, %{"max_price" => max_price}) do
    from l in query, where: l.price <= ^max_price
  end
  def for_max_price(query, _), do: query

  def for_min_price(query, %{"min_price" => min_price}) do
    from l in query, where: l.price >= ^min_price
  end
  def for_min_price(query, _), do: query

  def for_max_surface(query, %{"max_surface" => max_surface}) do
    from l in query, where: l.surface <= ^max_surface
  end
  def for_max_surface(query, _), do: query

  def for_min_surface(query, %{"min_surface" => min_surface}) do
    from l in query, where: l.surface >= ^min_surface
  end
  def for_min_surface(query, _), do: query

  @doc """
  Gets a single land.

  Raises `Ecto.NoResultsError` if the Land does not exist.

  ## Examples

      iex> get_land!(123)
      %Land{}

      iex> get_land!(456)
      ** (Ecto.NoResultsError)

  """
  def get_land!(id), do: Land |> preload([:city, [estate_agent: :contact]]) |> Repo.get!(id)

  @doc """
  Gets a single land by attributes.

  Raises `Ecto.NoResultsError` if the Land does not exist with those attributes.

  ## Examples

      iex> get_land_by!(%{id: 123, field: value})
      %Land{}

      iex> get_land_where!(%{id: 123, field: value})
      ** (Ecto.NoResultsError)

  """
  def get_land_by!(params), do: Land |> preload([:city, [estate_agent: :contact]]) |> Repo.get_by!(params)

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
    |> Ecto.Changeset.cast_assoc(:prospects_lands)
    |> Repo.insert()
    |> case do
      {:ok, land = %Land{}} ->
        {:ok, land |> Repo.preload([:city, [estate_agent: :contact]])}
      {:error, err} ->
        {:error, err}
    end
  end

  @doc """
  Updates a land.

  ## Examples

      iex> update_land(land, %{field: new_value})
      {:ok, %Land{}}

      iex> update_land(land, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_land(%Land{} = land, attrs) do
    land
    |> Land.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Land.

  ## Examples

      iex> delete_land(land)
      {:ok, %Land{}}

      iex> delete_land(land)
      {:error, %Ecto.Changeset{}}

  """
  def delete_land(%Land{} = land) do
    Repo.delete(land)
  end

  def find_matching_land(params) do
    Land
    |> preload(:ads)
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
    %LandAd{}
    |> LandAd.changeset(attrs)
    |> Repo.insert()
  end
end
