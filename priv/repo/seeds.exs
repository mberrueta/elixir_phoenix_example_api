# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs

Imdb.Repo.delete_all Imdb.Core.Director

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
  directors_id: peter_jackson.id,
})

the_lord_of_the_rings_the_two_towers = Imdb.Repo.insert!(%Imdb.Core.Movie{
  description: "second movie (2002)",
  labels: ["action", "adventure", "drama"],
  likes: 0,
  name: "The Lord of the Rings: The Two Towers",
  popular: true,
  rate: 0.0,
  directors_id: peter_jackson.id,
})

the_lord_of_the_rings_the_return_of_the_king = Imdb.Repo.insert!(%Imdb.Core.Movie{
  description: "third movie (2003)",
  labels: ["action", "adventure", "drama"],
  likes: 0,
  name: "The Lord of the Rings: The Return of the King",
  popular: true,
  rate: 0.0,
  directors_id: peter_jackson.id,
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
  directors_id: chris_nolan.id,
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
  directors_id: david_fincher.id,
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
  directors_id: terry_gilliam.id,
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
