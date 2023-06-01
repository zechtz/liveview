defmodule LiveViewAppWeb.LightLive do
  use LiveViewAppWeb, :live_view

  def mount(_params, _sesssion, socket) do
    # IO.inspect(self(), label: "MOUNT")
    socket = assign(socket, brightness: 10)
    {:ok, socket}
  end

  def render(assigns) do
    # IO.inspect(self(), label: "RENDER")

    ~H"""
    <h1>Front Porch Light</h1>
    <div id="light">
      <div class="meter">
        <span style={"width: #{@brightness}%"}>
          <%= @brightness %>
        </span>
      </div>
      <button phx-click="off">
        <img src="/images/light-off.svg" />
      </button>
      <button phx-click="down">
        <img src="/images/down.svg" />
      </button>
      <button phx-click="up">
        <img src="/images/up.svg" />
      </button>
      <button phx-click="on">
        <img src="/images/light-on.svg" />
      </button>
    </div>
    """
  end

  # handle_event
  def handle_event("on", _payload, socket) do
    # IO.inspect(self(), label: "ON")
    socket = assign(socket, brightness: 100)
    {:noreply, socket}
  end

  def handle_event("off", _payload, socket) do
    # IO.inspect(self(), label: "OFF")
    socket = assign(socket, brightness: 0)
    {:noreply, socket}
  end

  def handle_event("up", _payload, socket) do
    # brightness = socket.assigns.brightness + 10
    socket = update(socket, :brightness, &(&1 + 10))
    {:noreply, socket}
  end

  def handle_event("down", _payload, socket) do
    # brightness = socket.assigns.brightness - 10
    socket = update(socket, :brightness, &(&1 - 10))
    {:noreply, socket}
  end
end
