defmodule Imdb.CoreFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Imdb.Core` context.
  """

  @doc """
  Generate a director.
  """
  def director_fixture(attrs \\ %{}) do
    {:ok, director} =
      attrs
      |> Enum.into(%{
        full_name: "some full_name"
      })
      |> Imdb.Core.create_director()

    director
  end

  @doc """
  Generate a actor.
  """
  def actor_fixture(attrs \\ %{}) do
    {:ok, actor} =
      attrs
      |> Enum.into(%{
        full_name: "some full_name"
      })
      |> Imdb.Core.create_actor()

    actor
  end
end
