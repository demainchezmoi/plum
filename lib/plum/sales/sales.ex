defmodule Plum.Sales do
  @moduledoc """
  The Sales context.
  """

  import Ecto.Query, warn: false
  alias Plum.Repo

  alias Plum.Sales.Contact

  @doc """
  Returns the list of contact.

  ## Examples

      iex> list_contact()
      [%Contact{}, ...]

  """
  def list_contact do
    Repo.all(Contact)
  end

  @doc """
  Gets a single contact.

  Raises `Ecto.NoResultsError` if the Contact does not exist.

  ## Examples

      iex> get_contact!(123)
      %Contact{}

      iex> get_contact!(456)
      ** (Ecto.NoResultsError)

  """
  def get_contact!(id), do: Repo.get!(Contact, id)

  @doc """
  Creates a contact.

  ## Examples

      iex> create_contact(%{field: value})
      {:ok, %Contact{}}

      iex> create_contact(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_contact(attrs \\ %{}) do
    %Contact{}
    |> Contact.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a contact.

  ## Examples

      iex> update_contact(contact, %{field: new_value})
      {:ok, %Contact{}}

      iex> update_contact(contact, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_contact(%Contact{} = contact, attrs) do
    contact
    |> Contact.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Contact.

  ## Examples

      iex> delete_contact(contact)
      {:ok, %Contact{}}

      iex> delete_contact(contact)
      {:error, %Ecto.Changeset{}}

  """
  def delete_contact(%Contact{} = contact) do
    Repo.delete(contact)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking contact changes.

  ## Examples

      iex> change_contact(contact)
      %Ecto.Changeset{source: %Contact{}}

  """
  def change_contact(%Contact{} = contact) do
    Contact.changeset(contact, %{})
  end

  alias Plum.Sales.Ad

  @doc """
  Returns the list of ad.

  ## Examples

      iex> list_ad()
      [%Ad{}, ...]

  """
  def list_ad do
    Repo.all(Ad)
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
  def get_ad!(id), do: Repo.get!(Ad, id)

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

  alias Plum.Sales.Land

  @doc """
  Returns the list of lands.

  ## Examples

      iex> list_lands()
      [%Land{}, ...]

  """
  def list_lands do
    Repo.all(Land)
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
  def get_land!(id), do: Repo.get!(Land, id)

  @doc """
  Creates a land.

  ## Examples

      iex> create_land(%{field: value})
      {:ok, %Land{}}

      iex> create_land(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_land(attrs \\ %{}) do
    %Land{}
    |> Land.changeset(attrs)
    |> Repo.insert()
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
