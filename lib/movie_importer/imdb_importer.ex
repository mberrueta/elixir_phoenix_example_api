defmodule MovieImporter.ImdbImporter do
  alias MovieImporter.ImdbClient

  @moduledoc """
  Import movies from imdb.com based in the search and insert into the database
  """

  @doc """
  Execute the Importer

  ## Examples

  iex> MovieImporter.ImdbClient.import("inception")
  # {:ok, 3}

  ## Results
    - {:ok, n} n: number of imported movies
    - {:error, reason}

  ## Parameters
    - movie_name: String used to seek and import the movie (required)
  """
  def import(), do: {:error, "movie_name is required"}

  def import(movie_name) do
    #    IO.inspect(movie_name)

    case seek_response = movie_name |> ImdbClient.seek() do
      {:ok, %{"results" => nil, "errorMessage" => error}} ->
        error

      {:ok, list} ->
        {
          :ok,
          list |> Enum.map(fn movie -> store(movie) end)
        }

      _ ->
        seek_response
    end
  end

  defp store(%{
         actors_names: actors_names,
         description: description,
         directors_names: directors_names,
         labels: labels,
         rating: rating,
         title: title,
         votes: votes
       }) do
    [director_name | _] = directors_names
    director = get_or_create_director(director_name)

    {:ok, movie} =
      Imdb.Core.create_movie(%{
        description: description,
        labels: labels,
        likes: votes,
        name: title,
        popular: rating >= 9.0,
        rate: rating,
        director_id: director.id
      })

    actors_list =
      actors_names
      |> Enum.map(fn actor_name -> get_or_create_actor(actor_name) end)
      # ignore errors
      |> Enum.reject(&is_nil(&1))

    movie
    |> Imdb.Repo.preload(:actors)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:actors, actors_list)
    |> Imdb.Repo.update!()

    movie.id
  end

  # TODO: move to repo !!
  defp get_or_create_director(director_name) do
    case result = Imdb.Core.get_director_by_name(director_name) do
      %Imdb.Core.Director{} ->
        result

      _ ->
        case insert = Imdb.Core.create_director(%{"full_name" => director_name}) do
          {:ok, director} -> director
          _ -> insert
        end
    end
  end

  defp get_or_create_actor(actor_name) do
    case result = Imdb.Core.get_actor_by_name(actor_name) do
      %Imdb.Core.Actor{} ->
        result

      _ ->
        case Imdb.Core.create_actor(%{"full_name" => actor_name}) do
          {:ok, actor} -> actor
          _ -> nil
        end
    end
  end
end
