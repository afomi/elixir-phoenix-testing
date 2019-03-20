defmodule Hello.CardMember do
  use Ecto.Schema
  import Ecto.Changeset


  schema "card_members" do
    field :card_id, :id
    field :user_board_id, :id

    timestamps()
  end

  @doc false
  def changeset(card_member, attrs) do
    card_member
    |> cast(attrs, [])
    |> validate_required([])
  end
end
