defmodule Imdb.Repo.Migrations.AddActorsMoviesTable do
  use Ecto.Migration

  def change do
    create table(:actors_movies, primary_key: false) do
      add :actor_id, references(:actors, on_delete: :delete_all, type: :binary_id),
        primary_key: true

      add :movie_id, references(:movies, on_delete: :delete_all, type: :binary_id),
        primary_key: true
    end

    create index(:actors_movies, [:actor_id])
    create index(:actors_movies, [:movie_id])

    create unique_index(:actors_movies, [:actor_id, :movie_id], name: :actors_movies_unique_ix)
  end
end
