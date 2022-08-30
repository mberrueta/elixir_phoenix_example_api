defmodule ImdbWeb.MovieController do
  use ImdbWeb, :controller

  alias Imdb.Core
  alias Imdb.Core.Movie

  action_fallback ImdbWeb.FallbackController

  def index(conn, _params) do
    movies = Core.list_movies()
    render(conn, "index.json", movies: movies)
  end

  def create(conn, %{"movie" => movie_params}) do
    with {:ok, %Movie{} = movie} <- Core.create_movie(movie_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.movie_path(conn, :show, movie))
      |> render("show.json", movie: movie)
    end
  end

  def show(conn, %{"id" => id}) do
    movie = Core.get_movie!(id)
    render(conn, "show.json", movie: movie)
  end

  def update(conn, %{"id" => id, "movie" => movie_params}) do
    movie = Core.get_movie!(id)

    with {:ok, %Movie{} = movie} <- Core.update_movie(movie, movie_params) do
      render(conn, "show.json", movie: movie)
    end
  end

  def delete(conn, %{"id" => id}) do
    movie = Core.get_movie!(id)

    with {:ok, %Movie{}} <- Core.delete_movie(movie) do
      send_resp(conn, :no_content, "")
    end
  end
end
