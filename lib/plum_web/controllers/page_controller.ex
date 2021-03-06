defmodule PlumWeb.PageController do
  use PlumWeb, :controller
  alias Plum.Sales

  def index(conn, params) do
    conn |> render("index.html", params: params)
  end

  def merci(conn, _params) do
    conn |> render("merci.html")
  end

  def legal(conn, _params) do
    conn |> render("legal.html")
  end

  def confidentialite(conn, _params) do
    conn |> render("confidentialite.html")
  end

  def login(conn, _params) do
    conn |> render("login.html", query_params: conn.query_params)
  end

  def contact(conn, %{"contact" => contact_params}) do
    conn =
      if not is_undef(contact_params, "phone") do
        creation = NaiveDateTime.utc_now |> NaiveDateTime.to_iso8601
        Plum.Zapier.new_prospect(contact_params |> Map.put("creation", creation) |> format_phone_us)
        Sales.create_prospect_from_contact(contact_params)
        conn |> put_flash(:info, "Votre demande a bien été prise en compte.")
      else
        conn |> put_flash(:error, "Merci de renseigner votre numéro de téléphone afin que nous puissions vous contacter.")
      end
    conn |> redirect(to: page_path(conn, :index))
  end
  
  def format_phone_us(params = %{"phone" => phone}) do
    us_phone =
      phone
      |> String.replace(" ", "")
      |> String.replace("-", "")
      |> String.replace(".", "")
      |> String.replace(",", "")
      |> String.split("", trim: true)
      |> Enum.with_index
      |> Enum.reduce("", fn ({val, index}, acc) ->
        prepended = if index in [3, 6], do: "-", else: ""
        "#{acc}#{prepended}#{val}"
      end)
    params |> Map.put("phone", "#{phone} (#{us_phone})")
  end
  def format_phone_us(params), do: params

  def is_undef(params, field), do: params[field] == "" or is_nil(params[field])
end
