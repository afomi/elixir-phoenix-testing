defmodule Hello.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :text, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :card_id, references(:cards, on_delete: :nothing)

      timestamps()
    end

    create index(:comments, [:user_id])
    create index(:comments, [:card_id])
  end
end
