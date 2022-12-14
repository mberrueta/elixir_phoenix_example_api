# Imdb

Simple API to test relationships, tests and some libraries

## Model

```mermaid
erDiagram

    movies {
        character_varying name
        character_varying description
        uuid director_id
        int likes
        float rate
        bool popular
        array labels
    }

    directors {
        character_varying full_name
    }
    
    actors {
        character_varying full_name
    }
    
    actors_movies {
        uuid movie_id
        uuid actor_id
    }
    
    directors ||--o{ movies : "director_id"
    movies ||--o{ actors_movies : "movies_id"
    actors ||--o{ actors_movies : "actors_id"
```

## Cleaning code

```shell
mix setup
mix test

mix format # format code
mix credo # like rubocop
mix coverall.html # code coverage
mix deps.audit # libraries vulnerabilities check
mix sobelow # security static code check
mix dialyzer # static analysis tool for Erlang
mix docs # gen doc

mix phx.server
open http://localhost:4000/api/movies
```

## Routes

```shell
# simplified routes
mix phx.routes | grep '/api' | awk '{print $2 " " $3}' | sed '/.*Controller/d'

# seed some data
mix run priv/repo/seeds.exs

# Example filtering movies
curl http://localhost:4000/api/movies | jq . # all
curl http://localhost:4000/api/movies?name=monkeys | jq .
curl http://localhost:4000/api/movies\?description=first&min_likes=0&min_rate=0 | jq .
```

## Import

It require to set an `IMDB_API_KEY` env var with. You can get one for free at `https://imdb-api.com/`

```shell

echo "
IMDB_API_KEY=xxxx
" >> .env
export $(cat ./.env | sed 's/#.*//g' | xargs ) # nice trick 😀


iex -S mix

MovieImporter.ImdbImporter.import("Silence")

(from a in Actor, preload: [:movies]) |> Imdb.Repo.all()
(from m in Movie, preload: [:actors, :director]) |> Imdb.Repo.all()
```
