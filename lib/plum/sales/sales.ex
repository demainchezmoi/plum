defmodule Plum.Sales do
  @moduledoc """
  The Sales context.
  """

  import Ecto.Query, warn: false

  alias Plum.Repo
  alias Ecto.Changeset
  alias Plum.Sales.Ad

  use EctoConditionals, repo: Plum.Repo


  @doc """
  Returns the list of ad.

  ## Examples

      iex> list_ads()
      [%Ad{}, ...]

  """
  def list_ads do
    Ad
    |> order_by(desc: :inserted_at)
    |> preload(:land)
    |> Repo.all()
  end

  @doc """
  Gets a single ad.

  Raises `Ecto.NoResultsError` if the Ad does not exist.

  ## Examples

      iex> get_ad!(123)
      %Ad{}

      iex> get_ad!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ad!(id), do: Ad |> preload(:land) |> Repo.get!(id)

  @doc """
  Gets a single ad by attributes.

  Raises `Ecto.NoResultsError` if the Ad does not exist with those attributes.

  ## Examples

      iex> get_ad_by!(%{id: 123, active: true})
      %Ad{}

      iex> get_ad_where!(%{id: 123, active: false})
      ** (Ecto.NoResultsError)

  """
  def get_ad_by!(params), do: Repo.get_by!(Ad, params)

  @doc """
  Creates a ad.

  ## Examples

      iex> create_ad(%{field: value})
      {:ok, %Ad{}}

      iex> create_ad(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ad(attrs \\ %{}) do
    %Ad{}
    |> Ad.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a ad.

  ## Examples

      iex> update_ad(ad, %{field: new_value})
      {:ok, %Ad{}}

      iex> update_ad(ad, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ad(%Ad{} = ad, attrs) do
    ad
    |> Ad.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Ad.

  ## Examples

      iex> delete_ad(ad)
      {:ok, %Ad{}}

      iex> delete_ad(ad)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ad(%Ad{} = ad) do
    Repo.delete(ad)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ad changes.

  ## Examples

      iex> change_ad(ad)
      %Ecto.Changeset{source: %Ad{}}

  """
  def change_ad(%Ad{} = ad) do
    Ad.changeset(ad, %{})
  end

  @doc """
  Increments ad view count.

  ## Examples

      iex> increment_view_count!(ad)
      %Ad{}

  """
  def increment_view_count!(%Ad{} = ad) do
    {:ok, ad} = ad |> update_ad(%{view_count: ad.view_count + 1})
    ad
  end

  alias Plum.Sales.Land

  @doc """
  Returns the list of lands.

  ## Examples

      iex> list_lands()
      [%Land{}, ...]

  """
  def list_lands do
    Land
    |> preload(:ads)
    |> order_by(desc: :inserted_at)
    |> Repo.all
  end

  @doc """
  Gets a single land.

  Raises `Ecto.NoResultsError` if the Land does not exist.

  ## Examples

      iex> get_land!(123)
      %Land{}

      iex> get_land!(456)
      ** (Ecto.NoResultsError)

  """
  def get_land!(id), do: Land |> preload(:ads) |> Repo.get!(id)

  @doc """
  Gets a single land by attributes.

  Raises `Ecto.NoResultsError` if the Ad does not exist with those attributes.

  ## Examples

      iex> get_land_by!(%{id: 123, active: true})
      %Ad{}

      iex> get_land_where!(%{id: 123, active: false})
      ** (Ecto.NoResultsError)

  """
  def get_land_by!(params), do: Land |> preload(:ads) |> Repo.get_by!(params)

  @doc """
  Creates a land.

  ## Examples

      iex> create_land(%{field: value})
      {:ok, %Land{}}

      iex> create_land(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_land(attrs \\ %{}) do
    changeset =
      %Land{} |> Land.changeset(attrs)

    changeset =
      case (Map.get(attrs, "ads") || Map.get(attrs, :ads)) do
        ads when is_list(ads) and length(ads) > 0 ->
          changeset |> Changeset.put_assoc(:ads, Enum.map(ads, &Ad.changeset(%Ad{}, &1)))
        _ -> changeset
      end
        
    changeset |> Repo.insert()
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

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking land changes.

  ## Examples

      iex> change_land(land)
      %Ecto.Changeset{source: %Land{}}

  """
  def change_land(%Land{} = land) do
    Land.changeset(land, %{})
  end
end
