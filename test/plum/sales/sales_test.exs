defmodule Plum.SalesTest do
  use Plum.DataCase

  import Plum.Factory

  alias Plum.Sales

  alias Plum.Sales.{
    Contact,
    Prospect,
  }

  describe "prospects" do
    test "list_prospects/0 returns all prospects" do
      prospect = insert(:prospect)
      assert Sales.list_prospects() |> Enum.map(& &1.id) == [prospect.id]
    end

    test "get_prospect!/1 returns the prospect with given id" do
      prospect = insert(:prospect)
      assert Sales.get_prospect!(prospect.id).id == prospect.id
    end

    test "get_prospect_by!/2 returns the prospect with given id" do
      prospect = insert(:prospect)
      assert Sales.get_prospect_by!(%{id: prospect.id}).id == prospect.id
    end

    test "create_prospect/1 with valid data creates a prospect" do
      prospect_params = params_for(:prospect)
      assert {:ok, p = %Prospect{}} = Sales.create_prospect(prospect_params)
      p_id = p.id
      assert %Prospect{contact: %Contact{prospect_id: ^p_id}} = p |> Repo.preload(:contact)
    end

    test "create_prospect/1 with invalid data returns error changeset" do
      prospect_params = params_for(:prospect) |> Map.put(:max_budget, "abc")
      assert {:error, %Ecto.Changeset{}} = Sales.create_prospect(prospect_params)
    end

    test "update_prospect/2 with valid data updates the prospect" do
      prospect_params = params_for(:prospect)
      prospect = insert(:prospect, prospect_params)
      prospect_params_updated = prospect_params |> Map.put(:max_budget, 1_000)
      assert {:ok, prospect} = Sales.update_prospect(prospect, prospect_params_updated)
      assert %Prospect{} = prospect
      assert prospect.max_budget == prospect_params_updated.max_budget
    end

    test "update_prospect/2 with invalid data returns error changeset" do
      prospect_params = params_for(:prospect)
      prospect = insert(:prospect)
      prospect_params_updated = prospect_params |> Map.put(:max_budget, "abc")
      assert {:error, %Ecto.Changeset{}} = Sales.update_prospect(prospect, prospect_params_updated)
      assert prospect.max_budget == Sales.get_prospect!(prospect.id).max_budget
    end

    test "update_prospect/2 updates the cities association" do
      city1 = insert(:city)
      city2 = insert(:city)
      prospect = insert(:prospect, cities: [city1])
      params = %{"cities" => [%{"id" => city2.id}]}
      assert {:ok, prospect} = Sales.update_prospect(prospect, params)
      assoc_cities_ids = prospect |> Repo.preload(:cities) |> Map.get(:cities) |> Enum.map(& &1.id)
      assert city2.id in assoc_cities_ids 
      refute city1.id in assoc_cities_ids
    end

    test "update_prospect/2 updates the contact association" do
      prospect = insert(:prospect)
      first_name = "lloyd"
      params = %{"contact" => %{"id" => prospect.contact.id, "first_name" => first_name}}
      assert {:ok, prospect} = Sales.update_prospect(prospect, params)
      assert prospect |> Repo.preload(:contact) |> Map.get(:contact) |> Map.get(:first_name) == first_name
    end

    test "delete_prospect/1 deletes the prospect" do
      prospect = insert(:prospect)
      assert {:ok, %Prospect{}} = Sales.delete_prospect(prospect)
      assert_raise Ecto.NoResultsError, fn -> Sales.get_prospect!(prospect.id) end
    end

    test "change_prospect/1 returns a prospect changeset" do
      prospect = insert(:prospect)
      assert %Ecto.Changeset{} = Sales.change_prospect(prospect)
    end
  end

  describe "estate_agents" do
    test "estate_agents_autocomplete finds by first_name" do
      contact = insert(:contact, first_name: "Patrick", last_name: "Poirier")
      estate_agent = insert(:estate_agent, contact: contact)
      results = Sales.estate_agents_autocomplete(%{first_name: "patri"})
      ids = results |> Enum.map(& &1.id)
      assert estate_agent.id in ids
    end

    test "estate_agents_autocomplete rejects by first_name" do
      contact = insert(:contact, first_name: "Patrick", last_name: "Poirier")
      estate_agent = insert(:estate_agent, contact: contact)
      results = Sales.estate_agents_autocomplete(%{first_name: "jean paul"})
      ids = results |> Enum.map(& &1.id)
      refute estate_agent.id in ids
    end

    test "estate_agents_autocomplete rejects by company" do
      contact = insert(:contact, first_name: "Patrick", last_name: "Poirier")
      estate_agent = insert(:estate_agent, contact: contact)
      results = Sales.estate_agents_autocomplete(%{last_name: "Poirier", company: "trucmiche"})
      ids = results |> Enum.map(& &1.id)
      refute estate_agent.id in ids
    end
  end
end
