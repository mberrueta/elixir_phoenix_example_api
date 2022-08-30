defmodule Imdb.Repo.Migrations.CreateActors do
  use Ecto.Migration

  def change do
    create table :actors, primary_key: false do
      add :id, :binary_id, primary_key: true
      add :full_name, :string

      timestamps()
    end

    create unique_index(:actors, [:full_name], name: :actors_unique_ix)
  end
end
