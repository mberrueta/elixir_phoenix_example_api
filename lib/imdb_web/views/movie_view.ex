defmodule ImdbWeb.MovieView do
  use ImdbWeb, :view
  alias ImdbWeb.MovieView

  def render("index.json", %{movies: movies}) do
    %{data: render_many(movies, MovieView, "movie.json")}
  end

  def render("show.json", %{movie: movie}) do
    %{data: render_one(movie, MovieView, "movie.json")}
  end

  def render("movie.json", %{movie: movie}) do
    %{
      id: movie.id,
      name: movie.name,
      description: movie.description,
      likes: movie.likes,
      rate: movie.rate,
      popular: movie.popular,
      labels: movie.labels
    }
  end
end
