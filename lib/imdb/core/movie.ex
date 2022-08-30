defmodule Imdb.Core.Movie do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "movies" do
    field :description, :string
    field :labels, {:array, :string}
    field :likes, :integer
    field :name, :string
    field :popular, :boolean, default: false
    field :rate, :float
    field :directors_fk, :binary_id

    timestamps()
  end

  @doc false
  def changeset(movie, attrs) do
    movie
    |> cast(attrs, [:name, :description, :likes, :rate, :popular, :labels])
    |> validate_required([:name, :description, :likes, :rate, :popular, :labels])
  end
end
