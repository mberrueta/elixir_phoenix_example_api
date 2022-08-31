defmodule ImdbWeb.MovieControllerTest do
  use ImdbWeb.ConnCase
  import Imdb.CoreFixtures
  import Imdb.Test.Factories
  alias Imdb.Core.Movie

  @create_attrs %{
    description: "some description",
    labels: [],
    likes: 42,
    name: "some name",
    popular: true,
    rate: 120.5
  }
  @update_attrs %{
    description: "some updated description",
    labels: [],
    likes: 43,
    name: "some updated name",
    popular: false,
    rate: 456.7
  }
  @invalid_attrs %{description: nil, labels: nil, likes: nil, name: nil, popular: nil, rate: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index without search" do
    test "lists all movies", %{conn: conn} do
      %Movie{id: id} = insert(:movie)
      insert(:movie)

      conn = get(conn, Routes.movie_path(conn, :index))
      list = json_response(conn, 200)["data"]

      assert length(list) == 2
      [ %{ "id" => result_id } | _a] = list
      assert result_id === id
    end
  end

  describe "index with name filter" do
    test "lists only jedi movies", %{conn: conn} do
      %Movie{id: id1} = insert(:movie, %{ name: "the best jedi" })
      %Movie{id: id2} = insert(:movie, %{ name: "the last jedi" })
      %Movie{id: id3} = insert(:movie, %{ name: "the last jedi returns" })
      insert(:movie)
      insert(:movie)

      filters = %{ "filters" => %{ "name" => "jedi" }}
      conn = get(conn, Routes.movie_path(conn, :index, filters))
      list = json_response(conn, 200)["data"]

      assert length(list) == 3
      [ %{ "id" => result_id } | list] = list
      assert result_id === id1
      [ %{ "id" => result_id } | list] = list
      assert result_id === id2
      [ %{ "id" => result_id } | list] = list
      assert result_id === id3
    end
  end

  describe "index with description filter" do
    test "lists only foo movies", %{conn: conn} do
      %Movie{id: id1} = insert(:movie, %{ name: "bar", description: "foo" })
      %Movie{id: id2} = insert(:movie, %{ name: "xxx", description: "foo" })
      insert(:movie, %{ description: "xxx" })

      filters = %{ "filters" => %{ "description" => "foo" }}
      conn = get(conn, Routes.movie_path(conn, :index, filters))
      list = json_response(conn, 200)["data"]

      assert length(list) == 2
      [ %{ "id" => result_id } | list] = list
      assert result_id === id1
      [ %{ "id" => result_id } | list] = list
      assert result_id === id2
    end
  end

  describe "index with likes filter" do
    test "lists only movies with at least 13 likes", %{conn: conn} do
      %Movie{id: id1} = insert(:movie, %{ likes: 13 })
      %Movie{id: id2} = insert(:movie, %{ likes: 20 })
      insert(:movie, %{ likes: 12 })
      insert(:movie) # Max is 10
      insert(:movie)

      filters = %{ "filters" => %{ "min_likes" => 13 }}
      conn = get(conn, Routes.movie_path(conn, :index, filters))
      list = json_response(conn, 200)["data"]

      assert length(list) == 2
      [ %{ "id" => result_id } | list] = list
      assert result_id === id1
      [ %{ "id" => result_id } | list] = list
      assert result_id === id2
    end
  end

  describe "index with rate filter" do
    test "lists only movies with at least 1.2 rating", %{conn: conn} do
      %Movie{id: id1} = insert(:movie, %{ rate: 1.2 })
      %Movie{id: id2} = insert(:movie, %{ rate: 1.3 })
      insert(:movie, %{ rate: 1.1999 })
      insert(:movie) # Max is 1.0
      insert(:movie)

      filters = %{ "filters" => %{ "min_rate" => 1.2 }}
      conn = get(conn, Routes.movie_path(conn, :index, filters))
      list = json_response(conn, 200)["data"]

      assert length(list) == 2
      [ %{ "id" => result_id } | list] = list
      assert result_id === id1
      [ %{ "id" => result_id } | list] = list
      assert result_id === id2
    end
  end

  describe "index with multiple filter" do
    test "lists only jedy movies with at least 1.2 rating, 13 likes and foo desc", %{conn: conn} do
      %Movie{ id: id } = insert(:movie, %{
        name: "the best jedi",
        description: "foo",
        likes: 13,
        rate: 1.2
      })
      insert_list(100, :movie)

      filters = %{ "filters" => %{
        "name" => "jedi",
        "description" => "foo",
        "min_likes" => 13,
        "min_rate" => 1.2
        }
      }
      conn = get(conn, Routes.movie_path(conn, :index, filters))
      list = json_response(conn, 200)["data"]

      assert length(list) == 1
      [ %{ "id" => result_id } | list] = list
      assert result_id === id
    end
  end

  describe "create movie" do
    test "renders movie when data is valid", %{conn: conn} do
      conn = post(conn, Routes.movie_path(conn, :create), movie: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.movie_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "description" => "some description",
               "labels" => [],
               "likes" => 42,
               "name" => "some name",
               "popular" => true,
               "rate" => 120.5
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.movie_path(conn, :create), movie: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update movie" do
    setup [:create_movie]

    test "renders movie when data is valid", %{conn: conn, movie: %Movie{id: id} = movie} do
      conn = put(conn, Routes.movie_path(conn, :update, movie), movie: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.movie_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "description" => "some updated description",
               "labels" => [],
               "likes" => 43,
               "name" => "some updated name",
               "popular" => false,
               "rate" => 456.7
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, movie: movie} do
      conn = put(conn, Routes.movie_path(conn, :update, movie), movie: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete movie" do
    setup [:create_movie]

    test "deletes chosen movie", %{conn: conn, movie: movie} do
      conn = delete(conn, Routes.movie_path(conn, :delete, movie))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.movie_path(conn, :show, movie))
      end
    end
  end

  defp create_movie(_) do
    movie = movie_fixture()
    %{movie: movie}
  end
end
