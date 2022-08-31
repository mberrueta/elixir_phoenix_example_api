defmodule ImdbWeb.DirectorControllerTest do
  use ImdbWeb.ConnCase

  import Imdb.CoreFixtures

  alias Imdb.Core.Director

  @create_attrs %{
    full_name: "some full_name"
  }
  @update_attrs %{
    full_name: "some updated full_name"
  }
  @invalid_attrs %{full_name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all directors", %{conn: conn} do
      conn = get(conn, Routes.director_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create director" do
    test "renders director when data is valid", %{conn: conn} do
      conn = post(conn, Routes.director_path(conn, :create), director: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.director_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "full_name" => "some full_name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.director_path(conn, :create), director: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update director" do
    setup [:create_director]

    test "renders director when data is valid", %{
      conn: conn,
      director: %Director{id: id} = director
    } do
      conn = put(conn, Routes.director_path(conn, :update, director), director: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.director_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "full_name" => "some updated full_name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, director: director} do
      conn = put(conn, Routes.director_path(conn, :update, director), director: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete director" do
    setup [:create_director]

    test "deletes chosen director", %{conn: conn, director: director} do
      conn = delete(conn, Routes.director_path(conn, :delete, director))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.director_path(conn, :show, director))
      end
    end
  end

  defp create_director(_) do
    director = director_fixture()
    %{director: director}
  end
end
