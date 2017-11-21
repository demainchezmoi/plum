defmodule Plum.Zapier do
  @prospect_hook "https://hooks.zapier.com/hooks/catch/2734240/srur24/"
  def new_prospect(form), do: HTTPoison.post(@prospect_hook, form |> Poison.encode!)
end
