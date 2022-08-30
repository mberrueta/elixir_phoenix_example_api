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
end
