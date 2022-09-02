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
    IO.inspect(movie_name)

    case seek_response = movie_name |> ImdbClient.seek() do
      {:ok, %{"results" => nil, "errorMessage" => error}} -> IO.inspect(error)
      {:ok, %{"results" => results}} -> seek_response |> Enum.each(fn movie -> store(movie) end)
      _ -> IO.inspect(seek_response)
    end
  end

  defp store(title, description, nil, stars, genres, rating, votes),
    do: {:error, "director is required"}

  defp store(%{
         "title" => title,
         "description" => description,
         "directors_names" => directors_names,
         "actors_names" => actors_names,
         "labels" => labels,
         "rating" => rating,
         "votes" => votes
       }) do
    [director_name | _] = directors_names
    director_id = get_or_create_director(director_name)

    {:ok, movie} =
      Imdb.Core.create_movie(%{
        description: description,
        labels: labels,
        likes: votes,
        name: title,
        popular: rating >= 9.0,
        rate: rating,
        director_id: director_id
      })

    actors_list =
      actors_names
      |> Enum.map(fn actor_name -> get_or_create_actor(actor_name) end)

    IO.inspect(actors_list)
    IO.inspect(movie)

    #    not working
    #    ** (Postgrex.Error) ERROR 23503 (foreign_key_violation) insert or update on table "actors_movies" violates foreign key constraint "actors_movies_movie_id_fkey"
    #
    #                                                                                                                       table: actors_movies
    #                                                            constraint: actors_movies_movie_id_fkey
    #
    #                                                            Key (movie_id)=(11e0275f-0761-4e88-b599-5091279cdcf4) is not present in table "movies".
    #    movie
    #    |> Imdb.Repo.preload(:actors)
    #    |> Ecto.Changeset.change()
    #    |> Ecto.Changeset.put_assoc(:actors, actors_list)
    #    |> Imdb.Repo.update!()
  end

  # TODO: move to repo
  defp get_or_create_director(director_name) do
    case result = Imdb.Core.get_director_by_name(director_name) do
      %Imdb.Core.Director{:id => director_id} = director -> director_id
      _ -> Imdb.Core.create_director(%{"full_name" => director_name})
    end
  end

  defp get_or_create_actor(actor_name) do
    case result = Imdb.Core.get_actor_by_name(actor_name) do
      %Imdb.Core.Actor{} -> result
      _ -> Imdb.Core.create_actor(%{"full_name" => actor_name})
    end
  end
end
