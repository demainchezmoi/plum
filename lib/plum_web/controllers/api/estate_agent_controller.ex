defmodule PlumWeb.Api.EstateAgentController do
  use PlumWeb, :controller

  alias Plum.Sales
  alias Plum.Sales.{EstateAgent}

  action_fallback PlumWeb.FallbackController

  def autocomplete(conn, %{"search" => search}) do

    params = %{
      first_name: search["first_name"],
      last_name: search["last_name"],
      company: search["company"],
      phone_number: search["phone_number"],
      email: search["email"],
    }

    params =
      params
      |> Map.keys
      |> Enum.reject(& is_nil(params |> Map.get(&1)))
      |> Enum.reject(& params |> Map.get(&1) == "")
      |> Enum.map(&{&1, Map.get(params, &1)})
      |> Enum.into(%{})

    estate_agents = Sales.estate_agents_autocomplete(params)
    conn |> render("index.json", %{estate_agents: estate_agents})
  end

  def index(conn, _params) do
    estate_agents = Sales.list_estate_agents()
    conn |> render("index.json", estate_agents: estate_agents)
  end

  def create(conn, %{"estate_agent" => estate_agent_params}) do
    with {:ok, %EstateAgent{} = estate_agent} <- Sales.create_estate_agent(estate_agent_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_estate_agent_path(conn, :show, estate_agent))
      |> render("show.json", estate_agent: estate_agent)
    end
  end

  def show(conn, %{"id" => id}) do
    estate_agent = Sales.get_estate_agent!(id)
    render(conn, "show.json", estate_agent: estate_agent)
  end

  def update(conn, %{"id" => id, "estate_agent" => estate_agent_params}) do
    estate_agent = Sales.get_estate_agent!(id)
    with {:ok, %EstateAgent{} = estate_agent} <- Sales.update_estate_agent(estate_agent, estate_agent_params) do
      render(conn, "show.json", estate_agent: estate_agent)
    end
  end

  def delete(conn, %{"id" => id}) do
    estate_agent = Sales.get_estate_agent!(id)
    with {:ok, %EstateAgent{}} <- Sales.delete_estate_agent(estate_agent) do
      conn |> render(PlumWeb.Api.SuccessView, "deleted.json")
    end
  end
end
