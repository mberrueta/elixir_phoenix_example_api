defmodule Imdb.Repo.Migrations.CreateDirectors do
  use Ecto.Migration

  def change do
    create table(:directors, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :full_name, :string

      timestamps()
    end

    create unique_index(:directors, [:full_name], name: :directors_unique_ix)
  end
end
