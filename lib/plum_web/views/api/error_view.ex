defmodule PlumWeb.Api.ErrorView do
  use PlumWeb, :view

  def render("400.json", _assigns) do
    %{error: "Bad request"}
  end

  def render("401.json", _assigns) do
    %{error: "Unauthorized"}
  end

  def render("403.json", _assigns) do
    %{error: "Forbidden"}
  end

  def render("404.json", _assigns) do
    %{error: "Not Found"}
  end

  def render("500.json", _assigns) do
    %{error: "Internal server error"}
  end
end

