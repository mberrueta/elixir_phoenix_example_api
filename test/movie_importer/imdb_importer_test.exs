defmodule MovieImporter.ImdbImporterTest do
  use Imdb.DataCase

  alias MovieImporter.{ImdbImporter, HttpClient}

  import Mock

  describe "#import(movie_name)" do
    @describetag :importer

    test "fail without name" do
      assert {:error, "movie_name is required"} = ImdbImporter.import()
    end

    test "without results" do
      with_mock HttpClient, get_http: fn _ -> {:ok, %{"results" => []}} end do
        assert {:ok, []} = ImdbImporter.import("something")
      end
    end

    test "with api error" do
      with_mock HttpClient,
        get_http: fn _ -> {:ok, %{"results" => nil, "errorMessage" => "boom"}} end do
        assert {:error, "boom"} = ImdbImporter.import("something")
      end
    end

    test "with results" do
      search_result = [%{"id" => "ID-a1"}, %{"id" => "ID-b2"}]

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
          cond do
            url |> String.contains?("something") -> {:ok, %{"results" => search_result}}
            url |> String.contains?("ID-a1") -> {:ok, movie1}
            url |> String.contains?("ID-b2") -> {:ok, movie2}
          end
        end do
        assert {:ok, list} = ImdbImporter.import("something")
        assert length(list) == 2

        [m1, m2] = Imdb.Core.list_movies(%{"name" => "something"}, [:director, :actors])

        assert m1.director.full_name == "some director"
        actor_names = m1.actors |> Enum.map(& &1.full_name)
        assert actor_names == ["some guy", "another one"]

        assert m2.director.full_name == "some director"
        actor_names = m2.actors |> Enum.map(& &1.full_name)
        assert actor_names == ["some guy", "another two"]
      end
    end
  end
end
