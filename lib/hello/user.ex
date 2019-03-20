defmodule Hello.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Hello.{Board, UserBoard}

  @derive {Jason.Encoder, only: [:id, :first_name, :last_name, :email]}

  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true
    field :first_name, :string
    field :last_name, :string

    has_many :owned_boards, Board
    has_many :user_boards, UserBoard
    has_many :boards, through: [:user_boards, :board]


    timestamps()
  end

  @required_fields ~w(first_name last_name email password)
  @optional_fields ~w(encrypted_password)

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :password], [:encrypted_password])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 5)
    |> validate_confirmation(:password, message: "Password does not match")
    |> unique_constraint(:email, message: "Email already taken")
    |> generate_encrypted_password
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Bcrypt.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset


  defp generate_encrypted_password(current_changeset) do
    case current_changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(current_changeset, :encrypted_password, Bcrypt.hash_pwd_salt(password))
      _ ->
        current_changeset
    end
  end
end
