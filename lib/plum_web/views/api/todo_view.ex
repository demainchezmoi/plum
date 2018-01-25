defmodule PlumWeb.Api.TodoView do
  use PlumWeb, :view

  alias PlumWeb.Api.{
    TodoView,
  }

  # import PlumWeb.ViewHelpers, only: [put_loaded_assoc: 2]

  @attributes ~w(
    done
    id
    priority
    prospect_id
    start_date
    title
  )a

  def render("index.json", params = %{todos: todos}) do
    %{
      data: render_many(todos, TodoView, "todo.json"),
      page_number: params[:page_number],
      total_pages: params[:total_pages],
    }
  end

  def render("show.json", %{todo: todo}) do
    %{data: render_one(todo, TodoView, "todo.json")}
  end

  def render("todo.json", %{todo: todo}) do
    todo
    |> Map.take(@attributes)
  end
end

