defmodule Imdb.Core.Movie do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "movies" do
    field :description, :string
    field :labels, {:array, :string}
    field :likes, :integer
    field :name, :string
    field :popular, :boolean, default: false
    field :rate, :float

    # field :director_id, :binary_id
    belongs_to :director, Imdb.Core.Director

    many_to_many :actors, Imdb.Core.Actor, join_through: "actors_movies"

    timestamps()
  end

  def changeset(movie, attrs) do
    movie
    |> cast(attrs, [:name, :description, :likes, :rate, :popular, :labels, :director_id])
    |> validate_required([:name, :description, :likes, :rate, :popular, :labels])
  end

  def search(query, filters \\ %{}, preload_options \\ []) do
    movie_name = get_in(filters, ["name"])
    movie_desc = get_in(filters, ["description"])
    min_rate = get_in(filters, ["min_rate"]) || 0.0
    min_likes = get_in(filters, ["min_likes"]) || 0

    from m in query,
      where:
        ilike(m.name, ^"%#{movie_name}%") and
          ilike(m.description, ^"%#{movie_desc}%") and
          m.rate >= ^min_rate and
          m.likes >= ^min_likes,
      preload: ^preload_options
  end
end
