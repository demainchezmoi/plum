defmodule Plum.Sales do
  @moduledoc """
  The Sales context.
  """

  import Ecto.Query, warn: false
  alias Plum.Repo
  use EctoConditionals, repo: Plum.Repo

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
  Gets a single ad by attributes.

  Raises `Ecto.NoResultsError` if the Ad does not exist with those attributes.

  ## Examples

      iex> get_ad_where!(123, %{active: true})
      %Ad{}

      iex> get_ad_where!(123, %{active: false})
      ** (Ecto.NoResultsError)

  """
  def get_ad_where!(id, params), do: Repo.get_by!(Ad, Map.put(params, :id, id))

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

  alias Plum.Sales.Project

  @doc """
  Returns the list of projects.

  ## Examples

      iex> list_projects()
      [%Project{}, ...]

  """
  def list_projects do
    Repo.all(Project)
  end

  @doc """
  Gets a single project.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get_project!(123)
      %Project{}

      iex> get_project!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project!(id), do: Repo.get!(Project, id)

  @doc """
  Creates a project.

  ## Examples

      iex> create_project(%{field: value})
      {:ok, %Project{}}

      iex> create_project(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project(attrs \\ %{}) do
    %Project{}
    |> Project.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a project.

  ## Examples

      iex> update_project(project, %{field: new_value})
      {:ok, %Project{}}

      iex> update_project(project, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project(%Project{} = project, attrs) do
    project
    |> Project.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Project.

  ## Examples

      iex> delete_project(project)
      {:ok, %Project{}}

      iex> delete_project(project)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project(%Project{} = project) do
    Repo.delete(project)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project changes.

  ## Examples

      iex> change_project(project)
      %Ecto.Changeset{source: %Project{}}

  """
  def change_project(%Project{} = project) do
    Project.changeset(project, %{})
  end

  @doc """
  Finds or create a project by attributes

  ## Examples

      iex> find_or_create_project(%{user_id: user_id, ad_id: ad_id})
      {:ok, %User{email: email}}

  """
  def find_or_create_project(attrs) do
    fields =
      attrs |> Map.keys |> Enum.map(fn
        f when is_binary(f) -> f |> String.to_atom
        f when is_atom(f) -> f
      end)
    Project |> struct(attrs) |> find_or_create_by(fields)
  end


  @doc """
  Gets a single project by attributes.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get_project_by!(%{id: 123, user_id: 456})
      %Project{}

      iex> get_project_by!(%{id: 456, user_id: 456})
      ** (Ecto.NoResultsError)

  """
  def get_project_by!(attrs), do: Repo.get_by!(Project, attrs)
end
