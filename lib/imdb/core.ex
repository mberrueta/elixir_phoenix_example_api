defmodule Imdb.Core do
  @moduledoc """
  The Core context.
  """

  import Ecto.Query, warn: false
  alias Imdb.Repo

  alias Imdb.Core.Director

  @doc """
  Returns the list of directors.

  ## Examples

      iex> list_directors()
      [%Director{}, ...]

  """
  def list_directors do
    Repo.all(Director)
  end

  @doc """
  Gets a single director.

  Raises `Ecto.NoResultsError` if the Director does not exist.

  ## Examples

      iex> get_director!(123)
      %Director{}

      iex> get_director!(456)
      ** (Ecto.NoResultsError)

  """
  def get_director!(id), do: Repo.get!(Director, id)

  @doc """
  Creates a director.

  ## Examples

      iex> create_director(%{field: value})
      {:ok, %Director{}}

      iex> create_director(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_director(attrs \\ %{}) do
    %Director{}
    |> Director.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a director.

  ## Examples

      iex> update_director(director, %{field: new_value})
      {:ok, %Director{}}

      iex> update_director(director, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_director(%Director{} = director, attrs) do
    director
    |> Director.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a director.

  ## Examples

      iex> delete_director(director)
      {:ok, %Director{}}

      iex> delete_director(director)
      {:error, %Ecto.Changeset{}}

  """
  def delete_director(%Director{} = director) do
    Repo.delete(director)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking director changes.

  ## Examples

      iex> change_director(director)
      %Ecto.Changeset{data: %Director{}}

  """
  def change_director(%Director{} = director, attrs \\ %{}) do
    Director.changeset(director, attrs)
  end

  alias Imdb.Core.Actor

  @doc """
  Returns the list of actors.

  ## Examples

      iex> list_actors()
      [%Actor{}, ...]

  """
  def list_actors do
    Repo.all(Actor)
  end

  @doc """
  Gets a single actor.

  Raises `Ecto.NoResultsError` if the Actor does not exist.

  ## Examples

      iex> get_actor!(123)
      %Actor{}

      iex> get_actor!(456)
      ** (Ecto.NoResultsError)

  """
  def get_actor!(id), do: Repo.get!(Actor, id)

  @doc """
  Creates a actor.

  ## Examples

      iex> create_actor(%{field: value})
      {:ok, %Actor{}}

      iex> create_actor(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_actor(attrs \\ %{}) do
    %Actor{}
    |> Actor.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a actor.

  ## Examples

      iex> update_actor(actor, %{field: new_value})
      {:ok, %Actor{}}

      iex> update_actor(actor, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_actor(%Actor{} = actor, attrs) do
    actor
    |> Actor.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a actor.

  ## Examples

      iex> delete_actor(actor)
      {:ok, %Actor{}}

      iex> delete_actor(actor)
      {:error, %Ecto.Changeset{}}

  """
  def delete_actor(%Actor{} = actor) do
    Repo.delete(actor)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking actor changes.

  ## Examples

      iex> change_actor(actor)
      %Ecto.Changeset{data: %Actor{}}

  """
  def change_actor(%Actor{} = actor, attrs \\ %{}) do
    Actor.changeset(actor, attrs)
  end
end