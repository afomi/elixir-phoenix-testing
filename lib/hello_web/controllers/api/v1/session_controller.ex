defmodule HelloWeb.SessionController do
  use HelloWeb, :controller

  plug :scrub_params, "session" when action in [:create]

  def create(conn, %{"session" => session_params}) do
    case HelloWeb.Session.authenticate(session_params) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} = Hello.Guardian.encode_and_sign(user)

        conn
        |> put_status(:created)
        |> render("show.json", jwt: jwt, user: user)

      :error ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json")
    end
  end

  def delete(conn, _) do
    # {:ok, claims} = Hello.Guardian.Plug.claims(conn)

    conn
    |> Hello.Guardian.Plug.sign_out()
    # |> Guardian.Plug.current_token
    # |> Guardian.revoke!(claims)

    conn
    |> render("delete.json")
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(:forbidden)
    |> render(HelloWeb.SessionView, "forbidden.json", error: "Not Authenticated")
  end
end
