# Imdb

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

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