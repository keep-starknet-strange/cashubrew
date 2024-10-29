defmodule Cashubrew.Web.Router do
  use Cashubrew.Web, :router
  import Phoenix.LiveDashboard.Router
  alias Cashubrew.Nuts.Nut01
  alias Cashubrew.Nuts.Nut02
  alias Cashubrew.Nuts.Nut03
  alias Cashubrew.Nuts.Nut04
  alias Cashubrew.Nuts.Nut05

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
    get(Nut02.Routes.v1_keys_for_keyset_id(), MintController, :keys_for_keyset)
    get(Nut02.Routes.v1_keyset(), MintController, :keysets)

    # NUT-03
    post(Nut03.Routes.v1_swap(), MintController, :swap)

    # NUT-04
    post(Nut04.Routes.v1_mint_quote(), MintController, :create_mint_quote)
    get(Nut04.Routes.v1_mint_quote_for_quote_id(), MintController, :get_mint_quote)
    post(Nut04.Routes.v1_mint(), MintController, :mint_tokens)

    post("/v1/melt/bolt11", MintController, :melt_tokens)
  end

  scope "/", Cashubrew.Web do
    pipe_through(:api)
    # NUT-06
    get("/v1/info", MintController, :info)
    # NUT-05
    post(Nut05.Routes.v1_melt_quote(), MintController, :create_melt_quote)
  end

  if Mix.env() == :dev do
    scope "/" do
      pipe_through(:browser)
      live_dashboard("/dashboard", metrics: Cashubrew.Web.Telemetry)
    end
  end
end
