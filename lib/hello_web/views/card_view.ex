defmodule HelloWeb.CardView do
  use HelloWeb, :view

  def render("show.json", %{card: card}) do
    card
  end
end
