defmodule LiveViewAppWeb.CustomComponents do
  use Phoenix.Component

  attr(:expiration, :integer, required: true)
  slot(:legal)
  slot(:inner_block, required: true)

  def promo(assigns) do
    ~H"""
    <div class="promo">
      <div class="deal">
        <%= render_slot(@inner_block) %>
      </div>
      <div class="expiration">
        Deal expires in <%= @expiration %> days
      </div>
      <div class="legal">
        <%= render_slot(@legal) %>
      </div>
    </div>
    """
  end

end
