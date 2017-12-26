defmodule Plum.Accounts do
  @moduledoc """
  The Accounts context.
  """

  @token_max_age 1_800

  import Ecto.Query, warn: false
  use EctoConditionals, repo: Plum.Repo

  alias PlumWeb.{Endpoint, Email, Mailer}
  alias Plum.{Repo, Accouts.User, Accounts.AuthToken}
  alias Phoenix.Token

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

  # ===============
  # Tokens
  # ===============

  @doc """
  Creates and sends a new magic login token to the user or email.
  """
  def provide_token(nil), do: {:error, :not_found}

  def provide_token(email) when is_binary(email) do
    User
    |> Repo.get_by(email: email)
    |> send_token()
  end

  def provide_token(user = %User{}) do
    send_token(user)
  end

  @doc """
  Checks the given token.
  """
  def verify_token_value(value) do
    AuthToken
    |> where([t], t.value == ^value)
    |> where([t], t.inserted_at > datetime_add(^Ecto.DateTime.utc, ^(@token_max_age * -1), "second"))
    |> Repo.one()
    |> verify_token()
  end

  # Unexpired token could not be found.
  defp verify_token(nil), do: {:error, :invalid}

  # Loads the user and deletes the token as it is now used once.
  defp verify_token(token) do
    token =
      token
      |> Repo.preload(:user)
      |> Repo.delete!

    user_id = token.user.id

    # verify the token matching the user id
    case Token.verify(Endpoint, "user", token.value, max_age: @token_max_age) do
      {:ok, ^user_id} ->
        {:ok, token.user}

      	# reason can be :invalid or :expired
      {:error, reason} ->
        {:error, reason}
    end
  end

  # User could not be found by email.
  defp send_token(nil), do: {:error, :not_found}

  # Creates a token and sends it to the user.
  defp send_token(user) do
    user
    |> create_token()
    |> Email.login_link(user)
    |> Mailer.deliver()

    {:ok, user}
  end

  # Creates a new token for the given user and returns the token value.
  defp create_token(user) do
    changeset = AuthToken.changeset(%AuthToken{}, user)
    auth_token = Repo.insert!(changeset)
    auth_token.value
  end

end
