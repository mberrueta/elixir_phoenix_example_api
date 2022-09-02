defmodule MovieImporter.ImdbClient do
  alias MovieImporter.HttpClient

  @moduledoc """
  Call IMDB in order to get movies data
  """

  @base_url "https://imdb-api.com/en/API"
  @api_key_not_present_error "IMDB_API_KEY environment variable is required. Look at https://imdb-api.com for one"

  @doc """
  Execute the import

  ## Examples

  iex> MovieImporter.ImdbClient.seek("inception")
  # {:ok,
  # %{
  #   "errorMessage" => "Maximum usage (111 of 100 per day)",
  #   "expression" => "inception",
  #   "results" => nil,
  #   "searchType" => "Movie"
  # }} :p

  ## Parameters
    - movie_name: String used to seek and import the movie (required)
  """
  def seek(), do: {:error, "movie_name is required"}

  def seek(movie_name) do
    case search_response = movie_name |> search_movies() do
      {:ok, %{"results" => nil, "errorMessage" => error}} ->
        {:error, error}

      {:ok, %{"results" => results}} ->
        #        IO.puts("seek movie -->")
        #        IO.inspect(results)

        {
          :ok,
          results |> get_movies()
        }

      _ ->
        search_response
    end
  end

  defp search_movies(movie_name) do
    movie_name
    |> search_url()
    |> HttpClient.get_http()
  end

  defp get_movies(map) do
    map
    |> Enum.take(2)
    |> Enum.map(fn %{"id" => id} -> id end)
    |> Enum.map(fn id ->
      case get_movie(id) do
        {:ok, movie} -> movie
        _ -> nil
      end
    end)
    |> Enum.reject(&is_nil(&1))
  end

  defp get_movie(id) do
    case movie_response = get_imdb_movie_information(id) do
      {:ok,
       %{
         "fullTitle" => title,
         "plot" => description,
         "directors" => directors,
         "stars" => stars,
         "genres" => genres,
         "imDbRating" => rating,
         "imDbRatingVotes" => votes
       }} ->
        {
          :ok,
          %{
            title: title,
            description: description,
            directors_names: directors |> String.split(","),
            actors_names: stars |> String.split(", "),
            labels: genres |> String.split(", "),
            rating: rating || 0.0,
            votes: votes || 0
          }
        }

      _ ->
        #        IO.inspect(movie_response)
        movie_response
    end
  end

  defp get_imdb_movie_information(id) do
    id
    |> movie_url()
    |> HttpClient.get_http()
  end

  defp search_url(movie_name) do
    "#{@base_url}/SearchMovie/#{api_key()}/#{movie_name}"
  end

  defp movie_url(id) do
    "#{@base_url}/Title/#{api_key()}/#{id}/Ratings"
  end

  defp api_key() do
    case key = System.get_env("IMDB_API_KEY") do
      nil -> raise @api_key_not_present_error
      "" -> raise @api_key_not_present_error
      _ -> key
    end
  end
end
