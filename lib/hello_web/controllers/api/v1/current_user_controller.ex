defmodule HelloWeb.CurrentUserController do
  use HelloWeb, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: HelloWeb.SessionController

  def show(conn, _) do
    user = Guardian.Plug.current_resource(conn)

    conn
    |> put_status(:ok)
    |> render("show.json", user: user)
  end
end
