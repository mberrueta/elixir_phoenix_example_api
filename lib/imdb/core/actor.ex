defmodule Imdb.Core.Actor do
  @moduledoc false
  
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "actors" do
    field :full_name, :string

    timestamps()
  end

  @doc false
  def changeset(actor, attrs) do
    actor
    |> cast(attrs, [:full_name])
    |> validate_required([:full_name])
  end
end
