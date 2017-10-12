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
  Gets a single project, preloads ad -> land.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get_project!(123)
      %Project{}

      iex> get_project!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project!(id), do: Project |> preload([ad: :land]) |> Repo.get!(id) 

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
      {:created, %Project{}}

      iex> find_or_create_project(%{user_id: user_id, ad_id: ad_id})
      {:found, %Project{}}

  """
  def find_or_create_project(attrs) do
    Project |> preload([ad: :land]) |> Repo.get_by(attrs) |> case do
      nil ->
        case create_project(attrs) do
          {:ok, project} -> {:created, project |> Repo.preload([ad: :land])}
          {:error, error} -> {:error, error}
        end
      project -> {:found, project}
    end
  end


  @doc """
  Gets a single project by attributes, preloads ad -> land.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get_project_by!(%{id: 123, user_id: 456})
      %Project{}

      iex> get_project_by!(%{id: 456, user_id: 456})
      ** (Ecto.NoResultsError)

  """
  def get_project_by!(attrs) do
    Project
    |> preload([ad: :land])
    |> Repo.get_by!(attrs)
  end


  @doc """
  Sets virtual field steps on project.

  ## Examples

    iex> %Project{} |> set_project_steps
    %Project{steps: steps}

  """

  def set_project_steps(%Project{} = project) do
    project |> Map.put(:steps, get_project_steps(project))
  end

  def get_project_steps(%Project{} = project) do
    [
      get_welcome_step(project),
      get_discover_land_step(project),
      get_discover_house_step(project),
      get_configure_house(project),
      get_evaluate_funding(project),
      get_phone_call(project),
      get_quotation(project),
      get_funding(project),
      get_visit_land(project),
      get_contract(project),
      get_permit(project),
      get_building(project),
      get_keys(project),
      get_after_sales(project),
    ]
    |> set_project_steps_status
  end

  defp get_welcome_step(_p), do: %{name: "welcome", valid: true}
  defp get_discover_land_step(p), do: %{name: "discover_land", valid: p.discover_land}
  defp get_discover_house_step(p), do: %{name: "discover_house", valid: p.discover_house}
  defp get_configure_house(p), do: %{name: "configure_house", valid: !!p.house_color_1 and !!p.house_color_2}
  defp get_evaluate_funding(p), do: %{name: "evaluate_funding", valid: (not is_nil p.net_income) and (not is_nil p.contribution)}
  defp get_phone_call(p), do: %{name: "phone_call", valid: p.phone_call}
  defp get_quotation(_project), do: %{name: "quotation", valid: false}
  defp get_funding(_project), do: %{name: "funding", valid: false}
  defp get_visit_land(_project), do: %{name: "visit_land", valid: false}
  defp get_contract(_project), do: %{name: "contract", valid: false}
  defp get_permit(_project), do: %{name: "permit", valid: false}
  defp get_building(_project), do: %{name: "building", valid: false}
  defp get_keys(_project), do: %{name: "keys", valid: false}
  defp get_after_sales(_project), do: %{name: "after_sales", valid: false}

  defp set_project_steps_status(steps, done_steps \\ [], over \\ false)
  defp set_project_steps_status([], done_steps, _over), do: done_steps
  defp set_project_steps_status([step|steps], done_steps, over) do
    step_status =
      cond do
        step.valid and not over -> "checked"
        not step.valid and not over -> "current"
        true -> "not_yet"
      end

    done_step = step |> Map.put(:status, step_status)
    over = step_status != "checked"
        
    set_project_steps_status(steps, done_steps ++ [done_step], over)
  end
end
