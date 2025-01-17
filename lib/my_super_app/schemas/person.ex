defmodule MySuperApp.Person do
  use Ecto.Schema
  import Ecto.Changeset

  schema "people" do
    field :name, :string
    field :age, :integer, default: 0
  end

  def changeset(person, params) do
    person
    |> cast(params, [:name, :age])
    |> validate_required([:name])
    |> validate_length(:name, min: 2)
  end
end
