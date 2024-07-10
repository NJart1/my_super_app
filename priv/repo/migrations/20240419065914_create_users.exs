defmodule MySuperApp.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :email, :string
    end

    create unique_index(:users, [:email])
  end
end
