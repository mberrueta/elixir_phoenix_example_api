defmodule ImdbWeb.ActorView do
  use ImdbWeb, :view
  alias ImdbWeb.ActorView

  def render("index.json", %{actors: actors}) do
    %{data: render_many(actors, ActorView, "actor.json")}
  end

  def render("show.json", %{actor: actor}) do
    %{data: render_one(actor, ActorView, "actor.json")}
  end

  def render("actor.json", %{actor: actor}) do
    %{
      id: actor.id,
      full_name: actor.full_name
    }
  end
end
