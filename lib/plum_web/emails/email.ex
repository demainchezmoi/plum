defmodule PlumWeb.Email do
  use Phoenix.Swoosh, view: PlumWeb.EmailView, layout: {PlumWeb.LayoutView, :email}
end
