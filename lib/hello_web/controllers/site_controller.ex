defmodule HelloWeb.SiteController do
  use HelloWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def show(conn, %{ "id" => id }) do
    render(conn, "show.html", id: id)
  end
end
