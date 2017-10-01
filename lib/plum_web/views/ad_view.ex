defmodule PlumWeb.AdView do
  use PlumWeb, :view

  def interested_url(ad, current_user) when not is_nil(current_user), do:
    ad_path(PlumWeb.Endpoint, :interested, ad)

  def interested_url(ad, _), do:
    "/auth/facebook?state=#{ad_path(PlumWeb.Endpoint, :interested, ad) |> URI.encode}"
end
