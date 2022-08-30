defmodule ImdbWeb.DirectorView do
  use ImdbWeb, :view
  alias ImdbWeb.DirectorView

  def render("index.json", %{directors: directors}) do
    %{data: render_many(directors, DirectorView, "director.json")}
  end

  def render("show.json", %{director: director}) do
    %{data: render_one(director, DirectorView, "director.json")}
  end

  def render("director.json", %{director: director}) do
    %{
      id: director.id,
      full_name: director.full_name
    }
  end
end
