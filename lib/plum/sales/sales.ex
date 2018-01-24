defmodule Plum.Sales do
  alias Ecto.Changeset
  alias Plum.Repo
  alias Plum.Sales.{Prospect, Contact, EstateAgent, ProspectLand}
  alias Plum.Geo
  alias Plum.Geo.{City}

  import Ecto.Query, warn: false

  # =============
  # Prospect
  # =============
  @doc """
  Returns the list of prospects.

  ## Examples

      iex> list_prospects()
      [%Prospect{}, ...]

  """
  def list_prospects(params \\ %{}) do
    list_prospects_query(params) |> Repo.all
  end

  @doc """
  Buids a query to fetch a list of prospects with filters
  """

  def list_prospects_query(params \\ %{}) do
    Prospect
    |> order_by(desc: :inserted_at)
    |> preload(:contact)
    |> preload(:cities)
    |> p_for_status(params)
    |> p_for_name(params)
  end

  def p_for_name(query, %{"prospect_name" => name}) when is_binary(name) and name != "" do
    from p in query,
      join: c in assoc(p, :contact),
      where: fragment("similarity(unaccent(? || ' ' || ?), unaccent(?)) > 0.2", c.first_name, c.last_name, ^name)
  end
  def p_for_name(query, _), do: query

  def p_for_status(query, %{"prospect_status" => "_active"}) do
    active_status = ~w(new search_land search_funding signing)
    from p in query, where: p.status in ^active_status
  end
  def p_for_status(query, %{
    "prospect_status" => prospect_status
  }) when is_binary(prospect_status) and prospect_status != "" do
    from p in query, where: p.status == ^prospect_status
  end
  def p_for_status(query, _), do: query

  @doc """
  Gets a single prospect.

  Raises `Ecto.NoResultsError` if the Prospect does not exist.

  ## Examples

      iex> get_prospect!(123)
      %Prospect{}

      iex> get_prospect!(456)
      ** (Ecto.NoResultsError)

  """
  def get_prospect!(id), do: Prospect |> preload(:contact) |> preload(:cities) |> Repo.get!(id)

  @doc """
  Gets a single prospect by attributes.

  Raises `Ecto.NoResultsError` if the Prospect does not exist with those attributes.

  ## Examples

      iex> get_prospect_by!(%{id: 123, field: value})
      %Prospect{}

      iex> get_prospect_where!(%{id: 123, field: value})
      ** (Ecto.NoResultsError)

  """
  def get_prospect_by!(params), do: Prospect |> preload(:contact) |> preload(:cities) |> Repo.get_by!(params)

  @doc """
  Creates a prospect.

  ## Examples

      iex> create_prospect(%{field: value})
      {:ok, %Prospect{}}

      iex> create_prospect(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_prospect(attrs \\ %{}) do
    changeset =
      %Prospect{}
      |> Prospect.changeset(attrs)
      |> Changeset.cast_assoc(:contact)
    changeset |> Repo.insert()
  end

  @doc """
  Creates a prospect from a contact form.
  """
  def create_prospect_from_contact(params) do
    {first_name, last_name} =
      case params["name"] do
        name when is_binary(name) ->
          [first_name|rest] = name |> String.split(" ")
          {first_name, rest |> Enum.join(" ")}
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

  @doc """
  Updates a prospect.

  ## Examples

      iex> update_prospect(prospect, %{field: new_value})
      {:ok, %Prospect{}}

      iex> update_prospect(prospect, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
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

  @doc """
  Deletes a Prospect.

  ## Examples

      iex> delete_prospect(prospect)
      {:ok, %Prospect{}}

      iex> delete_prospect(prospect)
      {:error, %Ecto.Changeset{}}

  """
  def delete_prospect(%Prospect{} = prospect) do
    Repo.delete(prospect)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking prospect changes.

  ## Examples

      iex> change_prospect(prospect)
      %Ecto.Changeset{source: %Prospect{}}

  """
  def change_prospect(%Prospect{} = prospect) do
    Prospect.changeset(prospect, %{})
  end

  # =============
  # ProspectLand
  # =============

  @doc """
  Creates or updates the given status association between a land and a prospect.
  Raises if there is an error.

  ## Examples

      iex> associate_prospect_land!(%{land_id: 1, prospect_id: 2, status: "interesting"})
      %ProspectLand{land_id: 1, prospect_id: 2, status: "interesting"}
  """

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

  @doc """
  Returns the list of estate_agents.

  ## Examples

      iex> list_estate_agents()
      [%EstateAgent{}, ...]

  """
  def list_estate_agents do
    EstateAgent |> preload(:contact) |> Repo.all
  end

  @doc """
  Gets a single estate_agent.

  Raises `Ecto.NoResultsError` if the EstateAgent does not exist.

  ## Examples

      iex> get_estate_agent!(123)
      %EstateAgent{}

      iex> get_estate_agent!(456)
      ** (Ecto.NoResultsError)

  """
  def get_estate_agent!(id), do: EstateAgent |> preload(:contact) |> preload(:lands) |> Repo.get!(id)

  @doc """
  Gets a single estate_agent by attributes.

  Raises `Ecto.NoResultsError` if the EstateAgent does not exist with those attributes.

  ## Examples

      iex> get_estate_agent_by!(%{id: 123, field: value})
      %EstateAgent{}

      iex> get_estate_agent_where!(%{id: 123, field: value})
      ** (Ecto.NoResultsError)

  """
  def get_estate_agent_by!(params), do: EstateAgent |> preload(:contact) |> preload(:lands) |> Repo.get_by!(params)

  @doc """
  Creates a estate_agent.

  ## Examples

      iex> create_estate_agent(%{field: value})
      {:ok, %EstateAgent{}}

      iex> create_estate_agent(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_estate_agent(attrs \\ %{}) do
    changeset =
      %EstateAgent{}
      |> EstateAgent.changeset(attrs)
      |> Changeset.cast_assoc(:contact)
    changeset |> Repo.insert()
  end

  @doc """
  Updates a estate_agent.

  ## Examples

      iex> update_estate_agent(estate_agent, %{field: new_value})
      {:ok, %EstateAgent{}}

      iex> update_estate_agent(estate_agent, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
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

  @doc """
  Deletes a EstateAgent.

  ## Examples

      iex> delete_estate_agent(estate_agent)
      {:ok, %EstateAgent{}}

      iex> delete_estate_agent(estate_agent)
      {:error, %Ecto.Changeset{}}

  """
  def delete_estate_agent(%EstateAgent{} = estate_agent) do
    Repo.delete(estate_agent)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking estate_agent changes.

  ## Examples

      iex> change_estate_agent(estate_agent)
      %Ecto.Changeset{source: %EstateAgent{}}

  """
  def change_estate_agent(%EstateAgent{} = estate_agent) do
    EstateAgent.changeset(estate_agent, %{})
  end

  @doc """
  Finds a list of estate agents matching a request

  ## Examples

      iex> estate_agents_autocomplete(%{
        phone_number: "123",
        name: "Bob"
      })
      [%EstateAgent{}, ...]
  """
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
    from ea in query,
      join: c in assoc(ea, :contact),
      where: fragment("EXISTS (SELECT 1 FROM jsonb_array_elements(to_jsonb(?)) as j(data) WHERE (data#>> '{value}') % ?)", c.phone_numbers, ^phone_number)
  end
  def ea_phone_like(query, _), do: query

  def ea_email_like(query, %{email: email}) do
    from ea in query,
      join: c in assoc(ea, :contact),
      where: fragment("EXISTS (SELECT 1 FROM jsonb_array_elements(to_jsonb(?)) as j(data) WHERE (data#>> '{value}') % ?)", c.emails, ^email)
  end
  def ea_email_like(query, _), do: query

  def ea_first_name_like(query, %{first_name: first_name}) do
    from ea in query,
      join: c in assoc(ea, :contact),
      where: fragment("unaccent(?) % unaccent(?)", c.first_name, ^first_name)
  end
  def ea_first_name_like(query, _), do: query

  def ea_last_name_like(query, %{last_name: last_name}) do
    from ea in query,
      join: c in assoc(ea, :contact),
      where: fragment("unaccent(?) % unaccent(?)", c.last_name, ^last_name)
  end
  def ea_last_name_like(query, _), do: query

  def ea_company_like(query, %{company: company}) do
    from ea in query,
      join: c in assoc(ea, :contact),
      where: fragment("unaccent(?) % unaccent(?)", c.company, ^company)
  end
  def ea_company_like(query, _), do: query
end
