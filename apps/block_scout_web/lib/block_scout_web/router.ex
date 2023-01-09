defmodule BlockScoutWeb.Router do
  use BlockScoutWeb, :router

  alias BlockScoutWeb.Plug.AllowIframe
  alias BlockScoutWeb.Plug.GraphQL
  alias BlockScoutWeb.{ApiRouter, WebRouter}

  if Application.compile_env(:block_scout_web, ApiRouter)[:wobserver_enabled] do
    forward("/wobserver", Wobserver.Web.Router)
  end

  if Application.compile_env(:block_scout_web, :admin_panel_enabled) do
    forward("/admin", BlockScoutWeb.AdminRouter)
  end

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(BlockScoutWeb.CSPHeader)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  forward("/insights/:entity/api", ApiRouter)

  if Application.compile_env(:block_scout_web, ApiRouter)[:reading_enabled] do
    # Needs to be 200 to support the schema introspection for graphiql
    @max_complexity 200

    forward("/insights/:entity/graphql", Absinthe.Plug,
      schema: BlockScoutWeb.Schema,
      analyze_complexity: true,
      max_complexity: @max_complexity
    )

    forward("/insights/:entity/graphiql", Absinthe.Plug.GraphiQL,
      schema: BlockScoutWeb.Schema,
      interface: :advanced,
      default_query: GraphQL.default_query(),
      socket: BlockScoutWeb.UserSocket,
      analyze_complexity: true,
      max_complexity: @max_complexity
    )
  else
    scope "/insights/:entity/", BlockScoutWeb do
      pipe_through([:browser, BlockScoutWeb.Plug.AllowIframe])
      get("/insights/:entity/api-docs", PageNotFoundController, :index)
      get("/insights/:entity/eth-rpc-api-docs", PageNotFoundController, :index)
    end
  end

  scope "/insights/:entity/", BlockScoutWeb do
    pipe_through([:browser, BlockScoutWeb.Plug.AllowIframe])

    get("/insights/:entity/api-docs", APIDocsController, :index)
    get("/insights/:entity/eth-rpc-api-docs", APIDocsController, :eth_rpc)
  end

  url_params = Application.compile_env(:block_scout_web, BlockScoutWeb.Endpoint)[:url]
  api_path = url_params[:api_path]
  path = url_params[:path]

  if path != api_path do
    scope to_string(api_path) <> "/insights/:entity/verify_smart_contract" do
      pipe_through(:api)

      post("/insights/:entity/contract_verifications", BlockScoutWeb.AddressContractVerificationController, :create)
    end
  else
    scope "/insights/:entity/verify_smart_contract" do
      pipe_through(:api)

      post("/insights/:entity/contract_verifications", BlockScoutWeb.AddressContractVerificationController, :create)
    end
  end

  if Application.compile_env(:block_scout_web, WebRouter)[:enabled] do
    forward("/insights/:entity/", BlockScoutWeb.WebRouter)
  else
    scope "/insights/:entity/", BlockScoutWeb do
      pipe_through(:browser)

      forward("/insights/:entity/", APIDocsController, :index)
    end
  end
end
