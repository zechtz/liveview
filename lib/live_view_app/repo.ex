defmodule LiveViewApp.Repo do
  use Ecto.Repo,
    otp_app: :live_view_app,
    adapter: Ecto.Adapters.Postgres
end
