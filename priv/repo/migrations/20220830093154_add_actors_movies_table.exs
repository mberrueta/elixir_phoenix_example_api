defmodule Imdb.Repo.Migrations.AddActorsMoviesTable do
  use Ecto.Migration

  def change do
    create table(:actors_movies, primary_key: false) do
      add :actors_fk, references(:actors, on_delete: :delete_all, type: :binary_id), primary_key: true
      add :movies_fk, references(:movies, on_delete: :delete_all, type: :binary_id), primary_key: true

      timestamps()
    end

    create index(:actors_movies, [:actors_fk])
    create index(:actors_movies, [:movies_fk])
  end
end
