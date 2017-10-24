defmodule PlumWeb.AuthController do
  @moduledoc """
  Auth controller responsible for handling Ueberauth responses
  """

  use PlumWeb, :controller
  alias Plum.Accounts
  alias Plum.Accounts.User
  plug Ueberauth

  alias Ueberauth.Strategy.Helpers

  @session_key Application.get_env(:plum, :session_key)

  def request(conn, _params) do
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Vous avez été déconnecté")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth = %{provider: :facebook}}} = conn, params) do
    with attrs <- extract_fb_user(auth),
         {status, user = %User{}} <- Accounts.upsert_user_by(attrs, :facebook_id),
         {:ok, session} <- Accounts.create_session(%{user_id: user.id})
    do
        conn
        |> put_session(@session_key, session.token)
        |> put_session(:_plum_user_status, status)
        |> redirect(to: params["state"] || "/")
    else
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
      _ ->
        conn
        |> put_flash(:error, "Une erreur est survenue.")
        |> redirect(to: "/")
    end
  end

  # def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    # conn
    # |> put_flash(:error, "Erreur d'authentification")
    # |> redirect(to: "/")
  # end

  def callback(conn, _params) do
    conn
    |> put_flash(:error, "Erreur d'authentification")
    |> redirect(to: "/")
  end

  defp extract_fb_user(%{info: info, uid: uid}) do
    %{
      email: info |> Map.get(:email),
      facebook_id: uid,
      first_name: info |> Map.get(:first_name),
      last_name: info |> Map.get(:last_name),
    }
  end

  defp extract_fb_user(_), do: {:error, "Profil incomplet"}
end
