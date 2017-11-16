defmodule Plum.Google do
  import PlumWeb.Router.Helpers

  def get_spreadsheets_token, do: get_token("https://www.googleapis.com/auth/spreadsheets")

  def get_token(scope) do
    {:ok, token} = Goth.Token.for_scope(scope)
    token
  end

  def get_conn(%Goth.Token{token: token}), do: GoogleApi.Sheets.V4.Connection.new(token)

  def append_row(spreadsheet_id, range, row) do
    token = get_spreadsheets_token()
    conn = get_conn(token)
    GoogleApi.Sheets.V4.Api.Spreadsheets.sheets_spreadsheets_values_append(conn, spreadsheet_id, range,
      body: %{range: range, values: [row]},
      valueInputOption: "RAW",
      insertDataOption: "INSERT_ROWS"
    )
  end

  def build_contact_row(%{"first_name" => first_name, "last_name" => last_name, "phone" => phone, "email" => email, "ad" => ad}) do
    creation = NaiveDateTime.utc_now |> NaiveDateTime.to_iso8601
    path = ad_url(PlumWeb.Endpoint, :public, ad)
    name = "#{first_name} #{last_name}"
    [creation, "", "maisons-leo.fr", name, phone, email, path]
  end
end
