defmodule MovieImporter.ImdbClient do
  @moduledoc """
  Import movies from imdb.com based in the search and insert into the database
  """

  @base_url "https://imdb-api.com/en/API"
  @api_key_not_present_error "IMDB_API_KEY environment variable is required. Look at https://imdb-api.com for one"

  @doc """
  Execute the import

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

    case seek_response = movie_name |> seek do
      {:ok, %{"results" => results}} -> results |> get_movies()
      _ -> IO.inspect(seek_response)
    end
  end

  defp seek(movie_name) do
    movie_name
    |> search_url()
    |> get_http()
  end

  defp get_movies(map) do
    map
    |> Enum.map(fn %{"id" => id} -> id end)
    |> Enum.each(fn id -> import_movie(id) end)
  end

  def import_movie(id) do
    case movie_response = get_movie_information(id) do
      {:ok,
       %{
         "fullTitle" => title,
         "plot" => description,
         "directors" => directors,
         "stars" => stars,
         "genres" => genres,
         "imDbRating" => rating,
         "imDbRatingVotes" => votes
       } = response} ->
        store(title, description, directors, stars, genres, rating, votes)

      _ ->
        IO.inspect(movie_response)
    end
  end

  defp store(title, description, nil, stars, genres, rating, votes), do: {:error, "director is required"}
  defp store(title, description, directors, stars, genres, rating, votes) do
    [director_name | _] = directors |> String.split(",")
    director_id = get_or_create_director(director_name)
    labels = genres |> String.split(", ")

    {:ok, movie} =
      Imdb.Core.create_movie(%{
        description: description,
        labels: labels,
        likes: votes || 0,
        name: title,
        popular: rating >= 9.0,
        rate: rating || 0.0,
        director_id: director_id
      })

    actors_list =
      stars
      |> String.split(", ")
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

  defp get_movie_information(id) do
    id
    |> movie_url()
    |> get_http()
  end

  defp search_url(movie_name) do
    "#{@base_url}/SearchMovie/#{api_key()}/#{movie_name}"
  end

  defp movie_url(id) do
    "#{@base_url}/Title/#{api_key()}/#{id}/Ratings"
  end

  defp get_http(url) do
    IO.inspect(url)

    :get
    |> Finch.build(url)
    |> Finch.request(MyConfiguredFinch)
    |> execute
  end

  defp api_key() do
    case key = System.get_env("IMDB_API_KEY") do
      nil -> raise @api_key_not_present_error
      "" -> raise @api_key_not_present_error
      _ -> key
    end
  end

  defp execute({:error, error}), do: {:error, error}

  defp execute({:ok, %Finch.Response{}} = request) do
    case request do
      {:ok, %Finch.Response{body: body, status: 200}} ->
        body |> Jason.decode()

      {:ok, %Finch.Response{body: body, status: status}} ->
        {:error, "#{status}: #{body}"}
    end
  end
end
