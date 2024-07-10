defmodule MySuperApp.Accounts do
  alias MySuperApp.{User, Repo}

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(id, attrs \\ %{}) do
    Repo.get!(User, id)
    |> User.changeset(attrs)
    |> Ecto.Changeset.change()
    |> Repo.update()
  end

  def delete_user(id) do
    Repo.get!(User, id)
    |> Repo.delete()
  end

  def change_user(user, attrs) do
    user
    |> User.changeset(attrs)
  end

  def get_users() do
    User
    |> Repo.all()
    |> Enum.map(& Map.from_struct(&1))
  end

  def get_user(id) do
    User
    |> Repo.get(id)
  end
end
