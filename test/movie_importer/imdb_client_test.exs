defmodule MovieImporter.ImdbClientTest do
  use Imdb.DataCase

  alias MovieImporter.{ImdbClient, HttpClient}

  import Mock
  import Imdb.CoreFixtures

  describe "#seek(movie_name)" do
    @describetag :importer

    test "fail without name" do
      assert {:error, "movie_name is required"} = ImdbClient.seek()
    end

    test "without results" do
      with_mock HttpClient, get_http: fn _ -> {:ok, %{"results" => []}} end do
        assert {:ok, []} = ImdbClient.seek("something")
      end
    end

    test "with api error" do
      with_mock HttpClient,
        get_http: fn _ -> {:ok, %{"results" => nil, "errorMessage" => "boom"}} end do
        assert {:error, "boom"} = ImdbClient.seek("something")
      end
    end

    test "with results" do
      search_result = [%{"id" => "ID-a1"}, %{"id" => "ID-b2"}]
      movie1 = %{"id" => "ID-a1", "name" => Faker.Food.dish()}
      movie2 = %{"id" => "ID-b2", "name" => Faker.Beer.name()}

      movie1 = %{
        "fullTitle" => "The somethings",
        "plot" => "wow is cool",
        "directors" => "some director",
        "stars" => "some guy, another one",
        "genres" => "a, b",
        "imDbRating" => 0.23,
        "imDbRatingVotes" => 2
      }

      movie2 = %{
        "fullTitle" => "The somethings are back",
        "plot" => "wow is more cool than 1",
        "directors" => "some director",
        "stars" => "some guy, another two",
        "genres" => "a",
        "imDbRating" => 0.13,
        "imDbRatingVotes" => 1
      }

      with_mock HttpClient,
        get_http: fn url ->
          IO.inspect(url)

          cond do
            url |> String.contains?("something") -> {:ok, %{"results" => search_result}}
            url |> String.contains?("ID-a1") -> {:ok, movie1}
            url |> String.contains?("ID-b2") -> {:ok, movie2}
          end
        end do
        assert {
                 :ok,
                 [
                   %{
                     actors_names: ["some guy", "another one"],
                     description: "wow is cool",
                     directors_names: ["some director"],
                     labels: ["a", "b"],
                     rating: 0.23,
                     title: "The somethings",
                     votes: 2
                   },
                   %{
                     actors_names: ["some guy", "another two"],
                     description: "wow is more cool than 1",
                     directors_names: ["some director"],
                     labels: ["a"],
                     rating: 0.13,
                     title: "The somethings are back",
                     votes: 1
                   }
                 ]
               } = ImdbClient.seek("something")
      end
    end
  end
end
