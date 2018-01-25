defmodule PlumWeb.Api.TodoController do
  use PlumWeb, :controller
  alias Plum.Repo
  alias Plum.Sales
  alias Plum.Sales.Todo

  action_fallback PlumWeb.FallbackController

  def index(conn, params) do
    todos_query = Sales.list_todos_query(params)
    page = todos_query |> Repo.paginate(params)
    render conn, "index.json",
      todos: page.entries,
      page_number: page.page_number,
      total_pages: page.total_pages
  end

  def create(conn, %{"todo" => todo_params}) do
    with {:ok, %Todo{} = todo} <- Sales.create_todo(todo_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_todo_path(conn, :show, todo))
      |> render("show.json", todo: todo)
    end
  end

  def show(conn, %{"id" => id}) do
    todo = Sales.get_todo!(id)
    render(conn, "show.json", todo: todo)
  end

  def update(conn, %{"id" => id, "todo" => todo_params}) do
    todo = Sales.get_todo!(id)
    with {:ok, %Todo{} = todo} <- Sales.update_todo(todo, todo_params) do
      render(conn, "show.json", todo: todo)
    end
  end

  def delete(conn, %{"id" => id}) do
    todo = Sales.get_todo!(id)
    with {:ok, %Todo{}} <- Sales.delete_todo(todo) do
      conn |> render(PlumWeb.Api.SuccessView, "deleted.json")
    end
  end
end


