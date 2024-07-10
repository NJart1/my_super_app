defmodule MySuperAppWeb.HomeLive do
  use MySuperAppWeb, :surface_live_view

  alias Moon.Design.Button

  def render(assigns) do
    ~F"""
    <Button
      class="bg-krillin"
      left_icon="generic_settings"
      size="xl"
      as="a"
      href={~p"/users"}
      animation="pulse"
    >
      ТЫК
    </Button>
    """
  end
end
