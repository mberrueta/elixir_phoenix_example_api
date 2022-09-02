defmodule MovieImporter.HttpClient do
  @moduledoc """
  Exec the http calls
  """

  @doc """
  GET request

  ## Examples

  iex> MovieImporter.HttpClient.get_http("https://catfact.ninja/fact")
  # {:ok,
  # %{
  #   "fact" => "Mountain lions are strong jumpers, thanks to muscular hind legs that are longer than their front legs.",
  #   "length" => 102
  # }}


  iex> MovieImporter.HttpClient.get_http("https://catfact.ninja/weeeeird")
  # {:error, "404: {\"message\":\"Not Found\",\"code\":404}"}

  ## Parameters
    url: String call (required)
  """
  def get_http(), do: {:error, "url is required"}

  def get_http(url) do
    IO.inspect(url)

    :get
    |> Finch.build(url)
    |> Finch.request(MyConfiguredFinch)
    |> execute
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
