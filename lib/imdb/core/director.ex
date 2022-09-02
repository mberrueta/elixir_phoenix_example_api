defmodule Imdb.Core.Director do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "directors" do
    field :full_name, :string

    has_many :movies, Imdb.Core.Movie

    timestamps()
  end

  @doc false
  def changeset(director, attrs) do
    director
    |> cast(attrs, [:full_name])
    |> validate_required([:full_name])
  end

  def search(query, name) do
    from d in query,
      where: ilike(d.full_name, ^name)
  end
end
