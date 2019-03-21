defmodule Hello.UserBoard do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias __MODULE__
  alias Hello.{User, Board}

  schema "user_boards" do
    belongs_to :user, User
    belongs_to :board, Board

    timestamps()
  end

  @required_fields ~w(user_id board_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(user_board, params \\ %{}) do
    user_board
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:user_id, name: :user_boards_user_id_board_id_index)
  end

  def find_by_user_and_board(query \\ %UserBoard{}, user_id, board_id) do
    from u in query,
    where: u.user_id == ^user_id and u.board_id == ^board_id
  end
end
