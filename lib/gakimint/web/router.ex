defmodule Gakimint.Web.Router do
  use Gakimint.Web, :router
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {Gakimint.Web.LayoutView, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", Gakimint.Web do
    pipe_through(:api)

    get("/v1/info", MintController, :info)
    get("/v1/keys", MintController, :keys)
    # Add other routes as needed
  end

  if Mix.env() == :dev do
    scope "/" do
      pipe_through(:browser)
      live_dashboard("/dashboard", metrics: Gakimint.Web.Telemetry)
    end
  end
end
