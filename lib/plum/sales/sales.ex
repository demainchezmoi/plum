defmodule Plum.Sales do
  alias Ecto.Changeset
  alias Plum.Repo
  alias Plum.Sales
  alias Plum.Sales.Prospect

  import Ecto.Query, warn: false

  @doc """
  Returns the list of prospects.

  ## Examples

      iex> list_prospects()
      [%Prospect{}, ...]

  """
  def list_prospects do
    Prospect
    |> order_by(desc: :inserted_at)
    |> Repo.all
  end

  @doc """
  Gets a single prospect.

  Raises `Ecto.NoResultsError` if the Prospect does not exist.

  ## Examples

      iex> get_prospect!(123)
      %Prospect{}

      iex> get_prospect!(456)
      ** (Ecto.NoResultsError)

  """
  def get_prospect!(id), do: Prospect |> Repo.get!(id)

  @doc """
  Gets a single prospect by attributes.

  Raises `Ecto.NoResultsError` if the Prospect does not exist with those attributes.

  ## Examples

      iex> get_prospect_by!(%{id: 123, field: value})
      %Prospect{}

      iex> get_prospect_where!(%{id: 123, field: value})
      ** (Ecto.NoResultsError)

  """
  def get_prospect_by!(params), do: Prospect |> Repo.get_by!(params)

  @doc """
  Creates a prospect.

  ## Examples

      iex> create_prospect(%{field: value})
      {:ok, %Prospect{}}

      iex> create_prospect(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_prospect(attrs \\ %{}) do
    changeset =
      %Prospect{}
      |> Prospect.changeset(attrs)
      |> Changeset.cast_assoc(:contact)
    changeset |> Repo.insert()
  end

  @doc """
  Updates a prospect.

  ## Examples

      iex> update_prospect(prospect, %{field: new_value})
      {:ok, %Prospect{}}

      iex> update_prospect(prospect, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_prospect(%Prospect{} = prospect, attrs) do
    prospect
    |> Prospect.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Prospect.

  ## Examples

      iex> delete_prospect(prospect)
      {:ok, %Prospect{}}

      iex> delete_prospect(prospect)
      {:error, %Ecto.Changeset{}}

  """
  def delete_prospect(%Prospect{} = prospect) do
    Repo.delete(prospect)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking prospect changes.

  ## Examples

      iex> change_prospect(prospect)
      %Ecto.Changeset{source: %Prospect{}}

  """
  def change_prospect(%Prospect{} = prospect) do
    Prospect.changeset(prospect, %{})
  end
end
