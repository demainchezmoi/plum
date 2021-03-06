defmodule PlumWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate
  alias Plug.Conn
  import Plum.Factory

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      import PlumWeb.Router.Helpers

      # The default endpoint for testing
      @endpoint PlumWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Plum.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Plum.Repo, {:shared, self()})
    end

    conn = Phoenix.ConnTest.build_conn()

    if tags[:logged_in] do
      roles =
        case tags[:logged_in] do
          true -> []
          roles when is_list(roles) -> roles
        end
      user = insert(:user, roles: roles)
      token = Phoenix.Token.sign(PlumWeb.Endpoint, "user", user.id)
      conn = Conn.assign(conn, :current_user, user)
      {:ok, conn: conn, current_user: user, token: token}
    else
      {:ok, conn: conn}
    end
  end
end
