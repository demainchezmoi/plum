defmodule PlumWeb.PageView do
  use PlumWeb, :view

  def login_cb(%{"redirect" => redirect}), do: "/auth/facebook?state=#{redirect}"
  def login_cb(_), do: "/auth/facebook"
end
