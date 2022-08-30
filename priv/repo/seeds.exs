# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs

Imdb.Repo.delete_all Imdb.Core.Director
Imdb.Repo.delete_all Imdb.Core.Actor

peter_jackson = Imdb.Repo.insert!(%Imdb.Core.Director{
  full_name: "Peter Jackson"
})

the_lord_of_the_rings_the_fellowship_of_the_ring = Imdb.Repo.insert!(%Imdb.Core.Movie{
  description: "first movie (2001)",
  labels: ["action", "adventure", "drama"],
  likes: 0,
  name: "The Lord of the Rings: The Fellowship of the Ring",
  popular: true,
  rate: 0.0,
  director: peter_jackson,
})

the_lord_of_the_rings_the_two_towers = Imdb.Repo.insert!(%Imdb.Core.Movie{
  description: "second movie (2002)",
  labels: ["action", "adventure", "drama"],
  likes: 0,
  name: "The Lord of the Rings: The Two Towers",
  popular: true,
  rate: 0.0,
  director: peter_jackson,
})

the_lord_of_the_rings_the_return_of_the_king = Imdb.Repo.insert!(%Imdb.Core.Movie{
  description: "third movie (2003)",
  labels: ["action", "adventure", "drama"],
  likes: 0,
  name: "The Lord of the Rings: The Return of the King",
  popular: true,
  rate: 0.0,
  director: peter_jackson,
})

chris_nolan = Imdb.Repo.insert!(%Imdb.Core.Director{
  full_name: "Christopher Nolan"
})

inception = Imdb.Repo.insert!(%Imdb.Core.Movie{
  description: "do you dream? (2010)",
  labels: ["action", "adventure", "sci-fi"],
  likes: 0,
  name: "Inception",
  popular: true,
  rate: 0.0,
  director: chris_nolan,
})

david_fincher = Imdb.Repo.insert!(%Imdb.Core.Director{
  full_name: "David Fincher"
})

fight_club = Imdb.Repo.insert!(%Imdb.Core.Movie{
  description: "crazy people (1999)",
  labels: ["drama"],
  likes: 0,
  name: "Fight club",
  popular: false,
  rate: 0.0,
  director: david_fincher,
})

terry_gilliam = Imdb.Repo.insert!(%Imdb.Core.Director{
  full_name: "Terry Gillian"
})

twelve_monkeys = Imdb.Repo.insert!(%Imdb.Core.Movie{
  description: "crazy movie (1995)",
  labels: ["mystery", "sci-fi", "thriller"],
  likes: 0,
  name: "12 Monkeys",
  popular: false,
  rate: 0.0,
  director: terry_gilliam,
})

brad_pitt = Imdb.Repo.insert!(%Imdb.Core.Actor{ full_name: "Brad Pitt" })
bruce_willies = Imdb.Repo.insert!(%Imdb.Core.Actor{ full_name: "Bruce Willies"})
edward_norton = Imdb.Repo.insert!(%Imdb.Core.Actor{ full_name: "Edward Norton"})
leonardo_dicaprio = Imdb.Repo.insert!(%Imdb.Core.Actor{ full_name: "Leonardo Dicaprio"})
elliot_page = Imdb.Repo.insert!(%Imdb.Core.Actor{ full_name: "Elliot Page"})
joseph_gordon = Imdb.Repo.insert!(%Imdb.Core.Actor{ full_name: "Joseph Gordon"})
elijah_wood = Imdb.Repo.insert!(%Imdb.Core.Actor{ full_name: "Elijah Wood"})
orlando_bloom = Imdb.Repo.insert!(%Imdb.Core.Actor{ full_name: "Orlando Bloom"})
sean_bean = Imdb.Repo.insert!(%Imdb.Core.Actor{ full_name: "Sean Bean"})

the_lord_of_the_rings_the_fellowship_of_the_ring
|> Imdb.Repo.preload(:actors)
|> Ecto.Changeset.change() # build changeset with current actors
|> Ecto.Changeset.put_assoc(:actors, [sean_bean, orlando_bloom, elijah_wood])
|> Imdb.Repo.update!

the_lord_of_the_rings_the_two_towers
|> Imdb.Repo.preload(:actors)
|> Ecto.Changeset.change() # build changeset with current actors
|> Ecto.Changeset.put_assoc(:actors, [sean_bean, orlando_bloom, elijah_wood])
|> Imdb.Repo.update!

the_lord_of_the_rings_the_return_of_the_king
|> Imdb.Repo.preload(:actors)
|> Ecto.Changeset.change() # build changeset with current actors
|> Ecto.Changeset.put_assoc(:actors, [sean_bean, orlando_bloom, elijah_wood])
|> Imdb.Repo.update!

inception
|> Imdb.Repo.preload(:actors)
|> Ecto.Changeset.change() # build changeset with current actors
|> Ecto.Changeset.put_assoc(:actors, [joseph_gordon, elliot_page, leonardo_dicaprio])
|> Imdb.Repo.update!

fight_club
|> Imdb.Repo.preload(:actors)
|> Ecto.Changeset.change() # build changeset with current actors
|> Ecto.Changeset.put_assoc(:actors, [brad_pitt, edward_norton])
|> Imdb.Repo.update!

twelve_monkeys
|> Imdb.Repo.preload(:actors)
|> Ecto.Changeset.change() # build changeset with current actors
|> Ecto.Changeset.put_assoc(:actors, [brad_pitt, bruce_willies])
|> Imdb.Repo.update!
