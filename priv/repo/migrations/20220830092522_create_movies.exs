defmodule Imdb.Repo.Migrations.CreateMovies do
  use Ecto.Migration

  def change do
    create table :movies, primary_key: false do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :string
      add :likes, :integer
      add :rate, :float
      add :popular, :boolean, default: false, null: false
      add :labels, {:array, :string}
      add :directors_fk, references(:directors, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:movies, [:directors_fk])
    create unique_index(:movies, [:name], name: :movies_unique_ix)
  end
end
