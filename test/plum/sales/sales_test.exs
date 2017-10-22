defmodule Plum.SalesTest do
  use Plum.DataCase
  alias Plum.Sales
  alias Plum.Sales.{
    Ad,
    Land,
    Project
  }
  import Plum.Factory

  describe "ad" do
    test "list_ads/0 returns all ad" do
      land = insert(:land)
      ad = land.ads |> List.first
      assert Sales.list_ads() |> Enum.map(& &1.id) == [ad.id]
    end

    test "get_ad!/1 returns the ad with given id" do
      land = insert(:land)
      ad = land.ads |> List.first
      assert Sales.get_ad!(ad.id)
    end

    test "get_ad_by!/2 returns the ad with given id" do
      land = insert(:land)
      ad = insert(:ad, land_id: land.id, active: false)
      assert Sales.get_ad_by!(%{id: ad.id, active: false}).id == ad.id
    end

    test "get_ad_by!/2 raises when ad doesn't match" do
      land = insert(:land)
      ad = insert(:ad, land_id: land.id, active: false)
      assert_raise Ecto.NoResultsError, fn -> Sales.get_ad_by!(%{id: ad.id, active: true}) end
    end

    test "create_ad/1 with valid data creates a ad" do
      land = insert(:land)
      ad_params = params_for(:ad) |> Map.put(:land_id, land.id)
      assert {:ok, %Ad{} = ad} = Sales.create_ad(ad_params)
      assert ad.land_id == land.id
    end

    test "create_ad/1 with invalid data returns error changeset" do
      insert(:land)
      ad_params = params_for(:ad) |> Map.put(:active, "string")
      assert {:error, %Ecto.Changeset{}} = Sales.create_ad(ad_params)
    end

    test "update_ad/2 with valid data updates the ad" do
      land = insert(:land)
      ad = land.ads |> List.first
      ad_params = params_for(:ad) |> Map.put(:land_id, land.id) |> Map.put(:active, false)
      assert {:ok, ad} = Sales.update_ad(ad, ad_params)
      assert %Ad{} = ad
      assert ad.active == false 
    end

    test "update_ad/2 with invalid data returns error changeset" do
      land = insert(:land)
      ad = land.ads |> List.first
      ad_params = params_for(:ad) |> Map.put(:active, "astring") 
      assert {:error, %Ecto.Changeset{}} = Sales.update_ad(ad, ad_params)
      assert ad.active == Sales.get_ad!(ad.id).active
    end

    test "delete_ad/1 deletes the ad" do
      land = insert(:land)
      ad = land.ads |> List.first
      assert {:ok, %Ad{}} = Sales.delete_ad(ad)
      assert_raise Ecto.NoResultsError, fn -> Sales.get_ad!(ad.id) end
    end

    test "change_ad/1 returns a ad changeset" do
      land = insert(:land)
      ad = land.ads |> List.first
      assert %Ecto.Changeset{} = Sales.change_ad(ad)
    end
  end

  describe "lands" do
    test "list_lands/0 returns all lands" do
      land = insert(:land)
      assert Sales.list_lands() |> Enum.map(& &1.id) == [land.id]
    end

    test "get_land!/1 returns the land with given id" do
      land = insert(:land)
      assert Sales.get_land!(land.id).id == land.id
    end

    test "get_land!/1 preloads the ads" do
      land = insert(:land)
      assert length(Sales.get_land!(land.id).ads) > 0 
    end

    test "get_land_by!/2 returns the land with given id" do
      land = insert(:land)
      assert Sales.get_land_by!(%{id: land.id}).id == land.id
    end

    test "get_land_by!/2 preloads the ads" do
      land = insert(:land)
      assert length(Sales.get_land_by!(%{id: land.id}).ads) > 0 
    end

    test "get_land_by!/2 raises when ad doesn't match" do
      land = insert(:land)
      assert_raise Ecto.NoResultsError, fn -> Sales.get_land_by!(%{id: land.id, surface: -1}) end
    end

    test "create_land/1 with valid data creates a land" do
      land_params = params_for(:land)
      assert {:ok, %Land{description: _, images: _}} = Sales.create_land(land_params)
    end

    test "create_land/1 with valid data creates associated ads" do
      land_params = params_for(:land)
      assert {:ok, %Land{description: _, images: _, ads: ads, id: id}} = Sales.create_land(land_params)
      assert ads |> List.first |> Map.get(:land_id) == id
    end

    test "create_land/1 sets notary_fees" do
      land_params = params_for(:land) |> Map.delete(:notary_fees)
      assert {:ok, land} = Sales.create_land(land_params)
      assert land.notary_fees == Plum.Helpers.NotaryFees.notary_fees(land_params.price)
    end

    test "create_land/1 with invalid data returns error changeset" do
      land_params = params_for(:land) |> Map.delete(:price)
      assert {:error, %Ecto.Changeset{}} = Sales.create_land(land_params)
    end

    test "update_land/2 with valid data updates the land" do
      land_params = params_for(:land)
      land = insert(:land, land_params)
      land_params_updated = land_params |> Map.put(:surface, 10_000)
      assert {:ok, land} = Sales.update_land(land, land_params_updated)
      assert %Land{} = land
      assert land.surface == land_params_updated.surface
    end

    test "update_land/2 with invalid data returns error changeset" do
      land_params = params_for(:land)
      land = insert(:land)
      land_params_updated = land_params |> Map.put(:surface, nil)
      assert {:error, %Ecto.Changeset{}} = Sales.update_land(land, land_params_updated)
      assert land.surface == Sales.get_land!(land.id).surface
    end

    test "delete_land/1 deletes the land" do
      land = insert(:land)
      assert {:ok, %Land{}} = Sales.delete_land(land)
      assert_raise Ecto.NoResultsError, fn -> Sales.get_land!(land.id) end
    end

    test "change_land/1 returns a land changeset" do
      land = insert(:land)
      assert %Ecto.Changeset{} = Sales.change_land(land)
    end
  end

  describe "projects" do
    alias Plum.Sales.Project

    def project_fixture(_attrs \\ %{}) do
      user = insert(:user)
      ad = insert(:ad)
      insert(:project, user_id: user.id, ad_id: ad.id)
    end

    test "list_projects/0 returns all projects" do
      project = project_fixture()
      assert Sales.list_projects() == [project]
    end

    test "get_project!/1 returns the project with given id" do
      project = project_fixture()
      assert Sales.get_project!(project.id).id == project.id
    end

    test "get_project!/1 preloads the ad -> land" do
      land = insert(:land)
      ad = insert(:ad, land: land)
      user = insert(:user)
      project = insert(:project, ad_id: ad.id, user_id: user.id)
      assert Sales.get_project!(project.id).ad.land.id == land.id
    end

    test "get_project_by!/1 returns the project with given attributes" do
      user = insert(:user)
      ad = insert(:ad)
      project = insert(:project, user_id: user.id, ad_id: ad.id)
      assert Sales.get_project_by!(%{id: project.id, user_id: user.id}).id == project.id
    end

    test "get_project_by!/1 preloads the ad -> land" do
      user = insert(:user)
      land = insert(:land)
      ad = insert(:ad, land: land)
      project = insert(:project, user_id: user.id, ad_id: ad.id)
      assert Sales.get_project_by!(%{id: project.id, user_id: user.id}).ad.land.id == land.id
    end

    test "get_project_by!/1 raises for unfound attributes" do
      user = insert(:user)
      ad = insert(:ad)
      project = insert(:project, user_id: user.id, ad_id: ad.id)
      assert_raise Ecto.NoResultsError, fn -> Sales.get_project_by!(%{id: project.id, user_id: -1}) end
    end

    test "create_project/1 with valid data creates a project" do
      user = insert(:user)
      ad = insert(:ad)
      project_params = params_for(:project, user_id: user.id, ad_id: ad.id)
      assert {:ok, %Project{}} = Sales.create_project(project_params)
    end

    test "create_project/1 with invalid data returns error changeset" do
      project_params = params_for(:project)
      assert {:error, %Ecto.Changeset{}} = Sales.create_project(project_params)
    end

    test "update_project/2 with valid data updates the project" do
      project = project_fixture()
      ad = insert(:ad)
      project_params = %{ad_id: ad.id}
      assert {:ok, project} = Sales.update_project(project, project_params)
      assert %Project{} = project
    end

    test "update_project/2 with invalid data returns error changeset" do
      project = project_fixture()
      assert {:error, %Ecto.Changeset{}} = Sales.update_project(project, %{user_id: nil})
      assert project.user_id == Sales.get_project!(project.id).user_id
    end

    test "delete_project/1 deletes the project" do
      project = project_fixture()
      assert {:ok, %Project{}} = Sales.delete_project(project)
      assert_raise Ecto.NoResultsError, fn -> Sales.get_project!(project.id) end
    end

    test "change_project/1 returns a project changeset" do
      project = project_fixture()
      assert %Ecto.Changeset{} = Sales.change_project(project)
    end

    test "set_project_steps/1 set the steps" do
      user = insert(:user)
      ad = insert(:ad)

      project = insert :project,
        user_id: user.id,
        ad_id: ad.id,
        discover_land: true,
        discover_house: false

      expected_step_1 = %{valid: false, name: "discover_house", status: "current"}
      expected_step_2 = %{valid: true, name: "discover_land", status: "not_yet"}

      assert Sales.set_project_steps(project).steps |> Enum.at(0) == expected_step_1
      assert Sales.set_project_steps(project).steps |> Enum.at(1) == expected_step_2
    end
  end

  test "find_or_create_project creates project" do
    %{id: user_id} = insert(:user)
    %{id: land_id} = insert(:land)
    %{id: ad_id} = insert(:ad, land_id: land_id)

    params = %{user_id: user_id, ad_id: ad_id}
    assert {:created, project = %Project{user_id: ^user_id, ad_id: ^ad_id}} = Sales.find_or_create_project(params)
    assert project.ad.land.id
    assert Sales.get_project_by!(params)
  end

  test "find_or_create_project finds project" do
    %{id: user_id} = insert(:user)
    %{id: land_id} = insert(:land)
    %{id: ad_id} = insert(:ad, land_id: land_id)
    %{id: _project_id} = insert(:project, user_id: user_id, ad_id: ad_id)

    params = %{user_id: user_id, ad_id: ad_id}
    assert {:found, project = %Project{id: _project_id}} = Sales.find_or_create_project(params)
    assert project.ad.land.id
    assert Sales.get_project_by!(params)
  end
end
