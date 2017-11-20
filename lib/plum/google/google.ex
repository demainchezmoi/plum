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

  def sort_sheet_by_date(spreadsheet_id) do
    sort_sheet(spreadsheet_id, 0, "DESCENDING")
  end

  def sort_sheet(spreadsheet_id, col, order) do
    token = get_spreadsheets_token()
    conn = get_conn(token)
    GoogleApi.Sheets.V4.Api.Spreadsheets.sheets_spreadsheets_batch_update(
      conn,
      spreadsheet_id,
      body: %{
        requests: [
          %{
            sortRange: %{
              range: %{
                startRowIndex: 0,
                startColumnIndex: 0
              },
              sortSpecs: [
                %{
                  dimensionIndex: col,
                  sortOrder: order
                }
              ]
            }
          }
        ]
      }
    )
  end
end
