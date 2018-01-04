defmodule PlumWeb.Api.EstateAgentView do
  use PlumWeb, :view

  alias PlumWeb.Api.{
    ContactView,
    EstateAgentView,
    LandView,
  }

  import PlumWeb.ViewHelpers, only: [put_loaded_assoc: 2]

  @attributes ~w(
    id
    notes
    inserted_at
    lands
    contact
  )a

  def render("index.json", %{estate_agents: estate_agents}) do
    %{data: render_many(estate_agents, EstateAgentView, "estate_agent.json")}
  end

  def render("show.json", %{estate_agent: estate_agent}) do
    %{data: render_one(estate_agent, EstateAgentView, "estate_agent.json")}
  end

  def render("estate_agent.json", %{estate_agent: estate_agent}) do
    estate_agent
    |> Map.take(@attributes)
    |> put_loaded_assoc({:contact, ContactView, "show.json", :contact})
    |> put_loaded_assoc({:lands, LandView, "index.json", :lands})
  end
end

