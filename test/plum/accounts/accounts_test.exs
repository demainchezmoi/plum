defmodule Plum.AccountsTest do
  use Plum.DataCase

  alias Plum.Accounts
  use EctoConditionals, repo: Plum.Repo

  import Plum.Factory
  alias Plum.Accounts.{
    Session,
    User,
  }

  describe "users" do

    test "list_users/0 returns all users" do
      user = insert(:user)
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = insert(:user)
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      user_params = params_for(:user)
      assert {:ok, %User{} = user} = Accounts.create_user(user_params)
      assert user.admin == user_params.admin
      assert user.email == user_params.email 
    end

    test "create_user/1 with invalid data returns error changeset" do
      user_params = params_for(:user) |> Map.put(:admin, "123")
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(user_params)
    end

    test "update_user/2 with valid data updates the user" do
      user = insert(:user)
      email = user.email <> "x"
      user_params = %{email: email}
      assert {:ok, user} = Accounts.update_user(user, user_params)
      assert %User{} = user
      assert user.email == email 
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = insert(:user)
      user_params = %{admin: "123"}
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, user_params)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = insert(:user)
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = insert(:user)
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end

    test "upsert_user_by/2 inserts a User" do
      user_params = params_for(:user)
      assert {:ok, %User{}} = Accounts.upsert_user_by(user_params, :email)
    end

    test "upsert_user_by/2 updates a User" do
      %{email: email, id: id} = insert(:user, admin: false)
      user_params = params_for(:user, admin: true, email: email)
      assert {:ok, %User{id: ^id, email: ^email, admin: true}} = Accounts.upsert_user_by(user_params, :email)
    end
  end


  describe "sessions" do
    test "change_session/1 returns a user changeset" do
      user = insert(:user)
      session = insert(:session, user_id: user.id)
      assert %Ecto.Changeset{} = Accounts.change_session(session)
    end

    test "create_session/1 with valid data creates a session" do
      user = insert(:user)
      session_params = params_for(:session, user: user)
      assert {:ok, %Session{} = session} = Accounts.create_session(session_params)
      assert session.user_id == user.id
      assert session.token 
    end

    test "create_session/1 with invalid data returns error changeset" do
      session_params = params_for(:session) |> Map.put(:token, 123)
      assert {:error, %Ecto.Changeset{}} = Accounts.create_session(session_params)
    end

    test "get_session_by/2 finds a session by token" do
      session = insert(:session)
      assert ^session = Accounts.get_session_by(session.token, :token)
    end

    test "get_session_by/2 returns nil for unknown token" do
      assert is_nil Accounts.get_session_by("=====", :token)
    end
  end
end
