defmodule LiveViewAppWeb.SalesLive do
  use LiveViewAppWeb, :live_view
  alias LiveViewApp.Sales

  def mount(_params, _session, socket) do
    if connected?(socket) do
      # send message
      :timer.send_interval(1000, self(), :tick)
    end

    socket = socket |> assign_stats()
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Snapy Sales</h1>
    <div id="sales">
      <div class="stats">
        <div class="stat">
          <span class="value">
            <%= @new_orders %>
          </span>
          <span class="label">
            New Orders
          </span>
        </div>

        <div class="stat">
          <span class="value">
            <%= @sales_amount %>
          </span>
          <span class="label">
            Sales Amount
          </span>
        </div>

        <div class="stat">
          <span class="value">
            <%= @satisfaction %>
          </span>
          <span class="label">
            Satisfaction
          </span>
        </div>
      </div>
      <button phx-click="refresh"><img sr="/images/refresh.svg" /> Refresh</button>
    </div>
    """
  end

  def handle_event("refresh", _payload, socket) do
    {:noreply, socket |> assign_stats()}
  end

  def handle_info(:tick, socket) do
    {:noreply, socket |> assign_stats()}
  end

  defp assign_stats(socket) do
    assign(socket,
      new_orders: Sales.new_orders(),
      sales_amount: Sales.sales_amount(),
      satisfaction: Sales.satisfaction()
    )
  end
end
