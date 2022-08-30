defmodule Imdb.Core.Director do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "directors" do
    field :full_name, :string

    timestamps()
  end

  @doc false
  def changeset(director, attrs) do
    director
    |> cast(attrs, [:full_name])
    |> validate_required([:full_name])
  end
end
