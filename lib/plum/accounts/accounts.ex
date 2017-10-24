defmodule Plum.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Plum.Repo
  use EctoConditionals, repo: Plum.Repo

  alias Plum.Accounts.{
    Session,
    User
  }

  # ===============
  # Users
  # ===============

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Adds "admin" to user roles.
  Does nothing if user is already admin.

  ## Examples

      iex> make_admin(user)
      %User{roles: ["admin"]}

  """
  def make_admin(%User{} = user) do
    roles = ["admin" | user.roles] |> Enum.uniq
    user |> update_user(%{roles: roles})
  end


  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @doc """
  Updates or insert a user

  ## Examples

      iex> upsert_user_by(%{email: new_email}, :email)
      {:ok, %User{email: new_email}}

  """
  def upsert_user_by(attrs, field) do
    case User |> Repo.get_by(%{field => attrs[field]}) do
      nil ->
        attrs
        |> create_user
        |> map_succes_to(:inserted)

      user ->
        user
        |> update_user(attrs)
        |> map_succes_to(:updated)
    end
  end

  defp map_succes_to({:ok, struct}, to), do: {to, struct}
  defp map_succes_to(r = {:error, _struct}, _to), do: r 

  # ===============
  # Sessions
  # ===============

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking session changes.

  ## Examples

      iex> change_session(session)
      %Ecto.Changeset{source: %Session{}}

  """
  def change_session(%Session{} = session) do
    Session.changeset(session, %{})
  end


  @doc """
  Creates a session.

  ## Examples

      iex> create_session(%{field: value})
      {:ok, %Session{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_session(attrs \\ %{}) do
    %Session{}
    |> Session.changeset(attrs)
    |> Session.with_token()
    |> Repo.insert()
  end

  @doc """
  Gets a single session by field.

  ## Examples

      iex> get_session_by(123, :token)
      %Session{}

      iex> get_session_by(456, :token)
      nil

  """
  def get_session_by(value, field), do: Repo.get_by(Session, %{field => value})

end
