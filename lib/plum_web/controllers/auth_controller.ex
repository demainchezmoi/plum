defmodule PlumWeb.AuthController do
  @moduledoc """
  Auth controller responsible for handling Ueberauth responses
  """

  use PlumWeb, :controller
  alias Plum.Accounts
  plug Ueberauth

  alias Ueberauth.Strategy.Helpers

  def request(conn, _params) do
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Vous avez été déconnecté")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Erreur d'authentification")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    with attrs <- extract_user(auth),
         {:ok, user} <- Accounts.upsert_user_by(attrs, :email)
    do
        conn
        |> put_flash(:info, "Vous avez bien été authentifié")
        |> put_session(:current_user, user)
        |> redirect(to: "/")
    else
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
      _ ->
        conn
        |> put_flash(:error, "Erreur")
        |> redirect(to: "/")
    end
  end

  defp extract_user(%{info: %{email: email, name: name}, provider: provider, uid: uid}) do
    key = provider |> to_string |> (& &1 <> "_id").() |> String.to_atom 
    %{email: email, name: name} |> Map.put(key, uid)
  end

  defp extract_user(_), do: {:error, "Profil incomplet"}
end
