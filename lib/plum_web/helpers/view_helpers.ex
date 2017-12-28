defmodule PlumWeb.ViewHelpers do
  def put_loaded_assoc(struct, {key, view_module, method, view_key}) do
    case Map.get(struct, key) do
      %Ecto.Association.NotLoaded{} -> struct |> Map.delete(key)
      nil -> struct |> Map.delete(key)
      value ->
        rendered_sub_view = apply(view_module, :render, [
          method,
          %{view_key => value}
        ])
        Map.put(struct, key, rendered_sub_view[:data])
    end
  end
end
