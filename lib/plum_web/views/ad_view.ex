defmodule PlumWeb.AdView do
  use PlumWeb, :view

  def interested_url(ad, current_user) when not is_nil(current_user), do:
    ad_path(PlumWeb.Endpoint, :interested, ad)

  def interested_url(ad, _), do:
    ad_path(PlumWeb.Endpoint, :login, ad)

  def login_ad_cb(ad), do:
    "/auth/facebook?state=#{ad_path(PlumWeb.Endpoint, :interested, ad) |> URI.encode}"

  def lands_select(lands) do
    lands |> Enum.map(& {&1.city, &1.id})
  end

end
