defmodule Imdb.CoreTest do
  use Imdb.DataCase

  alias Imdb.Core

  describe "directors" do
    alias Imdb.Core.Director

    import Imdb.CoreFixtures

    @invalid_attrs %{full_name: nil}

    test "list_directors/0 returns all directors" do
      director = director_fixture()
      assert Core.list_directors() == [director]
    end

    test "get_director!/1 returns the director with given id" do
      director = director_fixture()
      assert Core.get_director!(director.id) == director
    end

    test "create_director/1 with valid data creates a director" do
      valid_attrs = %{full_name: "some full_name"}

      assert {:ok, %Director{} = director} = Core.create_director(valid_attrs)
      assert director.full_name == "some full_name"
    end

    test "create_director/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.create_director(@invalid_attrs)
    end

    test "update_director/2 with valid data updates the director" do
      director = director_fixture()
      update_attrs = %{full_name: "some updated full_name"}

      assert {:ok, %Director{} = director} = Core.update_director(director, update_attrs)
      assert director.full_name == "some updated full_name"
    end

    test "update_director/2 with invalid data returns error changeset" do
      director = director_fixture()
      assert {:error, %Ecto.Changeset{}} = Core.update_director(director, @invalid_attrs)
      assert director == Core.get_director!(director.id)
    end

    test "delete_director/1 deletes the director" do
      director = director_fixture()
      assert {:ok, %Director{}} = Core.delete_director(director)
      assert_raise Ecto.NoResultsError, fn -> Core.get_director!(director.id) end
    end

    test "change_director/1 returns a director changeset" do
      director = director_fixture()
      assert %Ecto.Changeset{} = Core.change_director(director)
    end
  end

  describe "actors" do
    alias Imdb.Core.Actor

    import Imdb.CoreFixtures

    @invalid_attrs %{full_name: nil}

    test "list_actors/0 returns all actors" do
      actor = actor_fixture()
      assert Core.list_actors() == [actor]
    end

    test "get_actor!/1 returns the actor with given id" do
      actor = actor_fixture()
      assert Core.get_actor!(actor.id) == actor
    end

    test "create_actor/1 with valid data creates a actor" do
      valid_attrs = %{full_name: "some full_name"}

      assert {:ok, %Actor{} = actor} = Core.create_actor(valid_attrs)
      assert actor.full_name == "some full_name"
    end

    test "create_actor/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.create_actor(@invalid_attrs)
    end

    test "update_actor/2 with valid data updates the actor" do
      actor = actor_fixture()
      update_attrs = %{full_name: "some updated full_name"}

      assert {:ok, %Actor{} = actor} = Core.update_actor(actor, update_attrs)
      assert actor.full_name == "some updated full_name"
    end

    test "update_actor/2 with invalid data returns error changeset" do
      actor = actor_fixture()
      assert {:error, %Ecto.Changeset{}} = Core.update_actor(actor, @invalid_attrs)
      assert actor == Core.get_actor!(actor.id)
    end

    test "delete_actor/1 deletes the actor" do
      actor = actor_fixture()
      assert {:ok, %Actor{}} = Core.delete_actor(actor)
      assert_raise Ecto.NoResultsError, fn -> Core.get_actor!(actor.id) end
    end

    test "change_actor/1 returns a actor changeset" do
      actor = actor_fixture()
      assert %Ecto.Changeset{} = Core.change_actor(actor)
    end
  end

  describe "movies" do
    alias Imdb.Core.Movie

    import Imdb.CoreFixtures

    @invalid_attrs %{description: nil, labels: nil, likes: nil, name: nil, popular: nil, rate: nil}

    test "list_movies/0 returns all movies" do
      movie = movie_fixture()
      assert Core.list_movies() == [movie]
    end

    test "get_movie!/1 returns the movie with given id" do
      movie = movie_fixture()
      assert Core.get_movie!(movie.id) == movie
    end

    test "create_movie/1 with valid data creates a movie" do
      valid_attrs = %{description: "some description", labels: [], likes: 42, name: "some name", popular: true, rate: 120.5}

      assert {:ok, %Movie{} = movie} = Core.create_movie(valid_attrs)
      assert movie.description == "some description"
      assert movie.labels == []
      assert movie.likes == 42
      assert movie.name == "some name"
      assert movie.popular == true
      assert movie.rate == 120.5
    end

    test "create_movie/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.create_movie(@invalid_attrs)
    end

    test "update_movie/2 with valid data updates the movie" do
      movie = movie_fixture()
      update_attrs = %{description: "some updated description", labels: [], likes: 43, name: "some updated name", popular: false, rate: 456.7}

      assert {:ok, %Movie{} = movie} = Core.update_movie(movie, update_attrs)
      assert movie.description == "some updated description"
      assert movie.labels == []
      assert movie.likes == 43
      assert movie.name == "some updated name"
      assert movie.popular == false
      assert movie.rate == 456.7
    end

    test "update_movie/2 with invalid data returns error changeset" do
      movie = movie_fixture()
      assert {:error, %Ecto.Changeset{}} = Core.update_movie(movie, @invalid_attrs)
      assert movie == Core.get_movie!(movie.id)
    end

    test "delete_movie/1 deletes the movie" do
      movie = movie_fixture()
      assert {:ok, %Movie{}} = Core.delete_movie(movie)
      assert_raise Ecto.NoResultsError, fn -> Core.get_movie!(movie.id) end
    end

    test "change_movie/1 returns a movie changeset" do
      movie = movie_fixture()
      assert %Ecto.Changeset{} = Core.change_movie(movie)
    end
  end
end
