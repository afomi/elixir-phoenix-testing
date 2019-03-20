defmodule HelloWeb.BoardController do
  use HelloWeb, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: HelloWeb.SessionController
  plug :scrub_params, "board" when action in [:create]

  alias Hello.{Repo, Board, UserBoard}

  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)

    owned_boards = current_user
      |> Ecto.assoc(:owned_boards)
      |> Board.preload_all
      |> Repo.all

    invited_boards = current_user
      |> Ecto.assoc(:boards)
      |> Board.not_owned_by(current_user.id)
      |> Board.preload_all
      |> Repo.all

    render(conn, "index.json", owned_boards: owned_boards, invited_boards: invited_boards)
  end

  def create(conn, %{"board" => board_params}) do
    current_user = Guardian.Plug.current_resource(conn)

    changeset = current_user
      |> Ecto.build_assoc(:owned_boards)
      |> Board.changeset(board_params)

    case Repo.insert(changeset) do
      {:ok, board} ->
        conn
        |> put_status(:created)
        |> render("show.json", board: board )
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
    end
  end
end
