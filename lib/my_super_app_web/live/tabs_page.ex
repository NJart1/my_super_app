defmodule MySuperAppWeb.TabsPage do
  use MySuperAppWeb, :surface_live_view

  alias Moon.Design.Tabs
  alias Moon.Design.Accordion
  alias Moon.Design.Table
  alias Moon.Design.Table.Column
  import MoonWeb.Helpers.Lorem

  alias MySuperApp.DbQueries

  prop(selected, :list, default: [])

  data(rooms_with_phones, :any, default: [])
  data(rooms_without_phones, :any, default: [])
  data(phones_no_rooms, :any, default: [])

  def mount(_params, _session, socket) do
    {
      :ok,
      assign(
        socket,
        rooms_with_phones: DbQueries.rooms_with_phones(),
        rooms_without_phones: DbQueries.rooms_without_phones(),
        phones_no_rooms: DbQueries.phones_without_rooms(),
        selected: []
      )
    }
  end

  def render(assigns) do
    ~F"""
    <Tabs id="tabs-ex-7">
      <Tabs.List>
        <Tabs.Tab class="hover:text-hit after:bg-hit" selected_class="text-hit after:scale-x-100">Rooms with phones</Tabs.Tab>
        <Tabs.Tab class="hover:text-hit after:bg-hit" selected_class="text-hit after:scale-x-100">Rooms without phones</Tabs.Tab>
        <Tabs.Tab class="hover:text-hit after:bg-hit" selected_class="text-hit after:scale-x-100">Phones without rooms</Tabs.Tab>
      </Tabs.List>
      <Tabs.Panels>
        <Tabs.Panel>
          <Table items={room <- @rooms_with_phones} row_click="single_row_click" {=@selected}>
            <Column label="Room Number">
              {room.room_number}
            </Column>

            <Column label="Phones">
              {#for {phone, index} <- room.phones |> Enum.with_index(1)}
                {#if index < room.phones |> Enum.count()}
                  {"#{phone.phone_number}, "}
                {#else}
                  {phone.phone_number}
                {/if}
              {/for}
            </Column>
          </Table>
        </Tabs.Panel>
        <Tabs.Panel>
          <Table items={room <- @rooms_without_phones}>
            <Column label="Room Number">
              {room.room_number}
            </Column>
          </Table>
        </Tabs.Panel>
        <Tabs.Panel>
          <Table items={phone <- @phones_no_rooms}>
            <Column label="Phone Number">
              {phone.phone_number}
            </Column>
          </Table>
        </Tabs.Panel>
      </Tabs.Panels>
    </Tabs>

    <Accordion id="single-accordion" is_single_open>
      <Accordion.Item>
        <Accordion.Header>Lorem</Accordion.Header>
        <Accordion.Content>{lorem()}</Accordion.Content>
      </Accordion.Item>
      <Accordion.Item>
        <Accordion.Header>Ipsum</Accordion.Header>
        <Accordion.Content>{ipsum()}</Accordion.Content>
      </Accordion.Item>
      <Accordion.Item>
        <Accordion.Header>Dolor</Accordion.Header>
        <Accordion.Content>{dolor()}</Accordion.Content>
      </Accordion.Item>
    </Accordion>
    """
  end

  def handle_event("single_row_click", %{"selected" => selected}, socket) do
    {:noreply, assign(socket, selected: [selected])}
  end
end
