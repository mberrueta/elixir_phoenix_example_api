defmodule ImdbWeb.DirectorController do
  use ImdbWeb, :controller

  alias Imdb.Core
  alias Imdb.Core.Director

  action_fallback ImdbWeb.FallbackController

  def index(conn, _params) do
    directors = Core.list_directors()
    render(conn, "index.json", directors: directors)
  end

  def create(conn, %{"director" => director_params}) do
    with {:ok, %Director{} = director} <- Core.create_director(director_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.director_path(conn, :show, director))
      |> render("show.json", director: director)
    end
  end

  def show(conn, %{"id" => id}) do
    director = Core.get_director!(id)
    render(conn, "show.json", director: director)
  end

  def update(conn, %{"id" => id, "director" => director_params}) do
    director = Core.get_director!(id)

    with {:ok, %Director{} = director} <- Core.update_director(director, director_params) do
      render(conn, "show.json", director: director)
    end
  end

  def delete(conn, %{"id" => id}) do
    director = Core.get_director!(id)

    with {:ok, %Director{}} <- Core.delete_director(director) do
      send_resp(conn, :no_content, "")
    end
  end
end
