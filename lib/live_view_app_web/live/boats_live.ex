defmodule LiveViewAppWeb.BoatsLive do
  use LiveViewAppWeb, :live_view

  alias LiveViewApp.Boats

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        filter: %{type: "", prices: []},
        boats: Boats.list_boats()
      )

    {:ok, socket}
  end

  def render(assigns) do
~H"""
    <h1>Daily Boat Rentals</h1>
    """
  end
end
