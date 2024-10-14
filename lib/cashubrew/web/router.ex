defmodule Cashubrew.Web.Router do
  use Cashubrew.Web, :router
  import Phoenix.LiveDashboard.Router
  alias Cashubrew.Nuts.Nut01

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {Cashubrew.Web.LayoutView, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", Cashubrew.Web do
    pipe_through(:api)

    # NUT-01 & NUT-02
    get(Nut01.Routes.v1_keys(), MintController, :keys)
    get(Nut01.Routes.v1_keys() <> "/:keyset_id", MintController, :keys_for_keyset)
    get("/v1/keysets", MintController, :keysets)

    # NUT-03
    post("/v1/swap", MintController, :swap)

    # NUT-04
    post("/v1/mint/quote/bolt11", MintController, :create_mint_quote)
    get("/v1/mint/quote/bolt11/:quote_id", MintController, :get_mint_quote)
    post("/v1/mint/bolt11", MintController, :mint_tokens)

    # NUT-05
    post("/v1/melt/quote/bolt11", MintController, :melt_quote)
    post("/v1/melt/bolt11", MintController, :melt_tokens)

    # NUT-06
    get("/v1/info", MintController, :info)
  end

  if Mix.env() == :dev do
    scope "/" do
      pipe_through(:browser)
      live_dashboard("/dashboard", metrics: Cashubrew.Web.Telemetry)
    end
  end
end
