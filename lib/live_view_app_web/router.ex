defmodule LiveViewAppWeb.Router do
  use LiveViewAppWeb, :router

  import LiveViewAppWeb.UserAuth

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {LiveViewAppWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug :fetch_current_user
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", LiveViewAppWeb do
    pipe_through(:browser)

    get("/", PageController, :home)
  end

  # Other scopes may use custom stacks.
  # scope "/api", LiveViewAppWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:live_view_app, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: LiveViewAppWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end

  ## Authentication routes

  scope "/", LiveViewAppWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{LiveViewAppWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    get "/sample-csv", CsvController, :index

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", LiveViewAppWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{LiveViewAppWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email

      live("/customers/import", CustomerLive.Import, :import)
      live("/lights", LightLive)
      live("/sandbox", SandboxLive)
      live("/sales", SalesLive)
      live("/flights", FlightLive)
      live("/boats", BoatsLive)
      live("/servers", ServersLive)
      live("/donations", DonationsLive)
      live("/volunteers", VolunteersLive)
      live("/topsecret", TopSecretLive)
      live("/presence", PresenceLive)
      live("/shop", ShopLive)
      live("/bookings", BookingsLive)
      live("/desks", DesksLive)
    end
  end

  scope "/", LiveViewAppWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{LiveViewAppWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end

# imagine, opening up a route and automatically getting a websocket connection 
# that has pub/sub 
