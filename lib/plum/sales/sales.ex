defmodule Plum.Sales do
  alias Ecto.Changeset
  alias Plum.Repo
  alias Plum.Sales.{Prospect, Contact, EstateAgent, ProspectLand, Todo}
  alias Plum.Geo
  alias Plum.Geo.{City}

  import Ecto.Query, warn: false

  # =============
  # Prospect
  # =============
  def list_prospects(params \\ %{}) do
    list_prospects_query(params) |> Repo.all
  end

  def list_prospects_query(params \\ %{}) do
    Prospect
    |> order_by(desc: :inserted_at)
    |> prospect_preloads
    |> p_for_status(params)
    |> p_for_name(params)
  end

  def prospect_preloads(query) do
    query |> preload(:contact) |> preload(:cities) |> preload(:todos)
  end

  def p_for_name(query, %{"prospect_name" => name}) when is_binary(name) and name != "" do
    # index needed
    from p in query,
      join: c in assoc(p, :contact),
      where: fragment("similarity(unaccent(? || ' ' || ?), unaccent(?)) > 0.2", c.first_name, c.last_name, ^name)
  end
  def p_for_name(query, _), do: query

  def p_for_status(query, %{"prospect_status" => "_active"}) do
    # index needed
    active_status = ~w(new search_land search_funding signing)
    from p in query, where: p.status in ^active_status
  end
  def p_for_status(query, %{
    "prospect_status" => prospect_status
  }) when is_binary(prospect_status) and prospect_status != "" do
    from p in query, where: p.status == ^prospect_status
  end
  def p_for_status(query, _), do: query

  def get_prospect!(id), do: Prospect |> prospect_preloads |> Repo.get!(id)

  def get_prospect_by!(params), do: Prospect |> prospect_preloads |> Repo.get_by!(params)

  def create_prospect(attrs \\ %{}) do
    changeset =
      %Prospect{}
      |> Prospect.changeset(attrs)
      |> Changeset.cast_assoc(:contact)
    changeset =
      case changeset.changes do
        %{to_be_called: true} ->
          changeset |> Changeset.put_assoc(:todos, [prospect_to_be_called_todo()])
        _ -> changeset
      end
    changeset |> Repo.insert()
  end

  def prospect_to_be_called_todo do
    %{
      title: "Premier contact",
      priority: 30,
      start_date: Date.utc_today(),
      end_date: Date.utc_today(),
    }
  end

  def create_prospect_from_contact(params) do
    {first_name, last_name} =
      case params["name"] do
        name when is_binary(name) ->
          [first_name|rest] = name |> String.split(" ")
          {
            first_name |> String.capitalize,
            rest |> Enum.map(&String.capitalize/1) |> Enum.join(" ")
          }
        nil ->
          {nil, nil}
      end
    prospect = %{
      contact: %{
        first_name: first_name,
        last_name: last_name,
        phone_numbers: [%{value: params["phone"], label: "Principal"}]
      },
      origin: "maisons-leo.fr",
      notes: params["remark"],
      to_be_called: true,
    }
    city = params["city"]
    postal_code = params["postal_code"]

    case create_prospect(prospect) do
      {:ok, prospect} ->
        case Geo.find_matching_city(city, postal_code) do
          %Geo.City{id: id} -> prospect |> update_prospect(%{"cities" => [%{"id" => id}]})
          nil -> prospect
        end
      {:error, changeset} -> {:error, changeset}
    end
  end

  def update_prospect(%Prospect{} = prospect, attrs) do
    changeset =
      prospect |> Repo.preload(:cities) |> Prospect.changeset(attrs)

    changeset =
      case attrs["contact"] do
        nil -> changeset
        contact_params ->
          contact = prospect |> Repo.preload(:contact) |> Map.get(:contact)
          contact_changeset = contact |> Contact.changeset(contact_params)
          changeset |> Changeset.put_assoc(:contact, contact_changeset)
      end

    changeset =
      case attrs["cities"] do
        cities when is_list(cities) ->
          city_ids = cities |> Enum.map(& &1["id"] || &1[:id])
          cities = City |> where([c], c.id in ^city_ids) |> Repo.all
          changeset |> Changeset.put_assoc(:cities, cities)
        _ ->
          changeset
      end

    changeset |> Repo.update()
  end

  def delete_prospect(%Prospect{} = prospect) do
    Repo.delete(prospect)
  end

  def change_prospect(%Prospect{} = prospect) do
    Prospect.changeset(prospect, %{})
  end

  # =============
  # ProspectLand
  # =============

  def associate_prospect_land!(params = %{
    prospect_id: _prospect_id,
    land_id: _land_id,
    status: _status
  }) do
    search_params = Map.delete(params, :status)
    case ProspectLand |> Repo.get_by(search_params) do
      nil ->
        %ProspectLand{} |> ProspectLand.changeset(params) |> Repo.insert!
      pl = %ProspectLand{} ->
        pl |> ProspectLand.changeset(params) |> Repo.update!
    end
  end


  # =============
  # EstateAgent
  # =============

  def list_estate_agents do
    EstateAgent |> preload(:contact) |> Repo.all
  end

  def get_estate_agent!(id), do: EstateAgent |> preload(:contact) |> preload(:lands) |> Repo.get!(id)

  def get_estate_agent_by!(params), do: EstateAgent |> preload(:contact) |> preload(:lands) |> Repo.get_by!(params)

  def create_estate_agent(attrs \\ %{}) do
    changeset =
      %EstateAgent{}
      |> EstateAgent.changeset(attrs)
      |> Changeset.cast_assoc(:contact)
    changeset |> Repo.insert()
  end

  def update_estate_agent(%EstateAgent{} = estate_agent, attrs) do
    changeset =
      estate_agent |> EstateAgent.changeset(attrs)

    changeset =
      case attrs["contact"] do
        nil -> changeset
        contact_params ->
          contact = estate_agent |> Repo.preload(:contact) |> Map.get(:contact)
          contact_changeset = contact |> Contact.changeset(contact_params)
          changeset |> Changeset.put_assoc(:contact, contact_changeset)
      end

    changeset |> Repo.update()
  end

  def delete_estate_agent(%EstateAgent{} = estate_agent) do
    Repo.delete(estate_agent)
  end

  def change_estate_agent(%EstateAgent{} = estate_agent) do
    EstateAgent.changeset(estate_agent, %{})
  end

  def estate_agents_autocomplete(params) do
    query =
      from ea in EstateAgent,
      preload: :contact,
      limit: 15

    query
    |> ea_first_name_like(params)
    |> ea_last_name_like(params)
    |> ea_company_like(params)
    |> ea_phone_like(params)
    |> ea_email_like(params)
    |> Repo.all
  end

  def ea_phone_like(query, %{phone_number: phone_number}) do
    # index needed
    from ea in query,
      join: c in assoc(ea, :contact),
      where: fragment("EXISTS (SELECT 1 FROM jsonb_array_elements(to_jsonb(?)) as j(data) WHERE (data#>> '{value}') % ?)", c.phone_numbers, ^phone_number)
  end
  def ea_phone_like(query, _), do: query

  def ea_email_like(query, %{email: email}) do
    # index needed
    from ea in query,
      join: c in assoc(ea, :contact),
      where: fragment("EXISTS (SELECT 1 FROM jsonb_array_elements(to_jsonb(?)) as j(data) WHERE (data#>> '{value}') % ?)", c.emails, ^email)
  end
  def ea_email_like(query, _), do: query

  def ea_first_name_like(query, %{first_name: first_name}) do
    # index needed
    from ea in query,
      join: c in assoc(ea, :contact),
      where: fragment("unaccent(?) % unaccent(?)", c.first_name, ^first_name)
  end
  def ea_first_name_like(query, _), do: query

  def ea_last_name_like(query, %{last_name: last_name}) do
    # index needed
    from ea in query,
      join: c in assoc(ea, :contact),
      where: fragment("unaccent(?) % unaccent(?)", c.last_name, ^last_name)
  end
  def ea_last_name_like(query, _), do: query

  def ea_company_like(query, %{company: company}) do
    # index needed
    from ea in query,
      join: c in assoc(ea, :contact),
      where: fragment("unaccent(?) % unaccent(?)", c.company, ^company)
  end
  def ea_company_like(query, _), do: query

  # =============
  # Todo
  # =============

  def list_todos_query(params \\ %{}) do
    Todo
    |> order_todos
    |> todo_preloads
    |> todo_for_done(params)
    |> todo_for_futur(params)
  end

  def order_todos(query) do
    from t in query, order_by: [asc: :end_date]
  end

  def todo_preloads(query) do
    query |> preload([prospect: :contact])
  end

  def list_todos(params \\ %{}) do
    list_todos_query(params) |> Repo.all
  end

  def todo_for_done(query, %{"done" => "both"}), do: query
  def todo_for_done(query, %{"done" => done}) when done in ["false", "true"]do
    # index needed
    done = if done == "true", do: true, else: false
    from t in query, where: t.done == ^done
  end
  def todo_for_done(query, _), do: query

  def todo_for_futur(query, %{"futur_todos" => "false"}) do
    # index needed
    date = Date.utc_today
    from t in query, where: t.start_date <= ^date
  end
  def todo_for_futur(query, _), do: query

  def get_todo!(id), do: Todo |> Repo.get!(id)

  # index needed ? check use cases
  def get_todo_by!(params), do: Todo |> Repo.get_by!(params)

  def create_todo(attrs \\ %{}) do
    changeset = %Todo{} |> Todo.changeset(attrs)
    changeset |> Repo.insert()
  end

  def update_todo(%Todo{} = todo, attrs) do
    changeset = todo |> Todo.changeset(attrs)
    changeset |> Repo.update()
  end

  def delete_todo(%Todo{} = todo) do
    Repo.delete(todo)
  end

  def change_todo(%Todo{} = todo) do
    Todo.changeset(todo, %{})
  end
end
