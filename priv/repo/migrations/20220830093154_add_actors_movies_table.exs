defmodule Imdb.Repo.Migrations.AddActorsMoviesTable do
  use Ecto.Migration

  def change do
    create table :actors_movies, primary_key: false do
      add :actors_id, references(:actors, on_delete: :delete_all, type: :binary_id), primary_key: true
      add :movies_id, references(:movies, on_delete: :delete_all, type: :binary_id), primary_key: true

      timestamps()
    end

    create index :actors_movies, [:actors_id]
    create index :actors_movies, [:movies_id]

    create unique_index(:actors_movies, [:actors_id, :movies_id], name: :actors_movies_unique_ix)
  end
end
