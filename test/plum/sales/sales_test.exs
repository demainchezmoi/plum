defmodule Plum.SalesTest do
  use Plum.DataCase

  import Plum.Factory

  alias Plum.Sales

  alias Plum.Sales.{
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
      assert {:ok, %Prospect{}} = Sales.create_prospect(prospect_params)
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
end
