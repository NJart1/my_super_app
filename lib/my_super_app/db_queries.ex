defmodule MySuperApp.DbQueries do
  alias MySuperApp.{Repo, Room}

  import Ecto.Query

  def rooms_with_phones_preload() do
    Room
    |> Repo.all()
    |> Repo.preload(:phones)
  end

  def rooms_with_phones() do
    Repo.all(
      from(room in Room,
        join: phones in assoc(room, :phones),
        preload: [phones: phones],
        select:
          map(
            room,
            [
              :id,
              :room_number,
              phones: [:id, :phone_number]
            ]
          )
      )
    )
  end

  def rooms_without_phones() do
    Repo.all(
      from(room in Room,
        left_join: phone in assoc(room, :phones),
        where: is_nil(phone.id),
        select: %{
          room_number: room.room_number
        }
      )
    )
  end

  def phones_without_rooms() do
    Repo.all(
      from(room in Room,
        right_join: phone in assoc(room, :phones),
        where: is_nil(room.id),
        select: %{
          phone_number: phone.phone_number
        }
      )
    )
  end
end
