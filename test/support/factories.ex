defmodule Imdb.Test.Factories do
  use ExMachina.Ecto, repo: Imdb.Repo

  def movie_factory do
    %Imdb.Core.Movie{
      name: Faker.Food.dish() |> sequence,
      description: Faker.Lorem.sentence(),
      likes: Enum.random(0..10),
      rate: :rand.uniform() |> Float.ceil(2),
      labels: ["hardcoded", Faker.Lorem.word()],
      popular: false
    }
  end
end
