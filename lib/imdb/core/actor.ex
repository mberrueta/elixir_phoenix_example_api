defmodule Imdb.Core.Actor do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "actors" do
    field :full_name, :string

    many_to_many :movies, Imdb.Core.Movie, join_through: "actors_movies"
    timestamps()
  end

  @doc false
  def changeset(actor, attrs) do
    actor
    |> cast(attrs, [:full_name])
    |> validate_required([:full_name])
  end

  # TODO: refactor. similar to director
  def search(query, name) do
    from a in query,
      where: ilike(a.full_name, ^name)
  end
end
