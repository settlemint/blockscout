defmodule BlockScoutWeb.WebRouter do
  @moduledoc """
  Router for web app
  """
  use BlockScoutWeb, :router
  require Ueberauth

  alias BlockScoutWeb.Plug.CheckAccountWeb

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(BlockScoutWeb.CSPHeader)
    plug(BlockScoutWeb.ChecksumAddress)
  end

  pipeline :account do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(CheckAccountWeb)
    plug(:protect_from_forgery)
    plug(BlockScoutWeb.CSPHeader)
    plug(BlockScoutWeb.ChecksumAddress)
  end

  if Mix.env() == :dev do
    forward("/insights/:entity/sent_emails", Bamboo.SentEmailViewerPlug)
  end

  scope "/insights/:entity/auth", BlockScoutWeb do
    pipe_through(:account)

    get("/insights/:entity/profile", Account.AuthController, :profile)
    get("/insights/:entity/logout", Account.AuthController, :logout)
    get("/insights/:entity/:provider", Account.AuthController, :request)
    get("/insights/:entity/:provider/callback", Account.AuthController, :callback)
  end

  scope "/insights/:entity/account", BlockScoutWeb do
    pipe_through(:account)

    resources("/insights/:entity/tag_address", Account.TagAddressController,
      only: [:index, :new, :create, :delete],
      as: :tag_address
    )

    resources("/insights/:entity/tag_transaction", Account.TagTransactionController,
      only: [:index, :new, :create, :delete],
      as: :tag_transaction
    )

    resources("/insights/:entity/watchlist", Account.WatchlistController,
      only: [:show],
      singleton: true,
      as: :watchlist
    )

    resources("/insights/:entity/watchlist_address", Account.WatchlistAddressController,
      only: [:new, :create, :edit, :update, :delete],
      as: :watchlist_address
    )

    resources("/insights/:entity/api_key", Account.ApiKeyController,
      only: [:new, :create, :edit, :update, :delete, :index],
      as: :api_key
    )

    resources("/insights/:entity/custom_abi", Account.CustomABIController,
      only: [:new, :create, :edit, :update, :delete, :index],
      as: :custom_abi
    )

    resources("/insights/:entity/public_tags_request", Account.PublicTagsRequestController,
      only: [:new, :create, :edit, :update, :delete, :index],
      as: :public_tags_request
    )
  end

  # Disallows Iframes (write routes)
  scope "/insights/:entity/", BlockScoutWeb do
    pipe_through(:browser)
  end

  # Allows Iframes (read-only routes)
  scope "/insights/:entity/", BlockScoutWeb do
    pipe_through([:browser, BlockScoutWeb.Plug.AllowIframe])

    resources("/insights/:entity/", ChainController, only: [:show], singleton: true, as: :chain)

    resources("/insights/:entity/market-history-chart", Chain.MarketHistoryChartController,
      only: [:show],
      singleton: true
    )

    resources("/insights/:entity/transaction-history-chart", Chain.TransactionHistoryChartController,
      only: [:show],
      singleton: true
    )

    resources "/insights/:entity/block", BlockController, only: [:show], param: "hash_or_number" do
      resources("/insights/:entity/transactions", BlockTransactionController, only: [:index], as: :transaction)
    end

    resources("/insights/:entity/blocks", BlockController, as: :blocks, only: [:index])

    resources "/insights/:entity/blocks", BlockController,
      as: :block_secondary,
      only: [:show],
      param: "hash_or_number" do
      resources("/insights/:entity/transactions", BlockTransactionController, only: [:index], as: :transaction)
    end

    get("/insights/:entity/reorgs", BlockController, :reorg, as: :reorg)

    get("/insights/:entity/uncles", BlockController, :uncle, as: :uncle)

    resources("/insights/:entity/pending-transactions", PendingTransactionController, only: [:index])

    resources("/insights/:entity/recent-transactions", RecentTransactionsController, only: [:index])

    resources("/insights/:entity/verified-contracts", VerifiedContractsController, only: [:index])

    get("/insights/:entity/txs", TransactionController, :index)

    resources "/insights/:entity/tx", TransactionController, only: [:show] do
      resources(
        "/insights/:entity/internal-transactions",
        TransactionInternalTransactionController,
        only: [:index],
        as: :internal_transaction
      )

      resources(
        "/insights/:entity/raw-trace",
        TransactionRawTraceController,
        only: [:index],
        as: :raw_trace
      )

      resources("/insights/:entity/logs", TransactionLogController, only: [:index], as: :log)

      resources("/insights/:entity/token-transfers", TransactionTokenTransferController,
        only: [:index],
        as: :token_transfer
      )

      resources("/insights/:entity/state", TransactionStateController,
        only: [:index],
        as: :state
      )
    end

    resources("/insights/:entity/accounts", AddressController, only: [:index])

    resources("/insights/:entity/tokens", TokensController, only: [:index])

    resources "/insights/:entity/address", AddressController, only: [:show] do
      resources("/insights/:entity/transactions", AddressTransactionController, only: [:index], as: :transaction)

      resources(
        "/insights/:entity/internal-transactions",
        AddressInternalTransactionController,
        only: [:index],
        as: :internal_transaction
      )

      resources(
        "/insights/:entity/validations",
        AddressValidationController,
        only: [:index],
        as: :validation
      )

      resources(
        "/insights/:entity/contracts",
        AddressContractController,
        only: [:index],
        as: :contract
      )

      resources(
        "/insights/:entity/decompiled-contracts",
        AddressDecompiledContractController,
        only: [:index],
        as: :decompiled_contract
      )

      resources(
        "/insights/:entity/logs",
        AddressLogsController,
        only: [:index],
        as: :logs
      )

      resources(
        "/insights/:entity/contract_verifications",
        AddressContractVerificationController,
        only: [:new],
        as: :verify_contract
      )

      resources(
        "/insights/:entity/verify-via-flattened-code",
        AddressContractVerificationViaFlattenedCodeController,
        only: [:new],
        as: :verify_contract_via_flattened_code
      )

      resources(
        "/insights/:entity/verify-via-metadata-json",
        AddressContractVerificationViaJsonController,
        only: [:new],
        as: :verify_contract_via_json
      )

      resources(
        "/insights/:entity/verify-via-standard-json-input",
        AddressContractVerificationViaStandardJsonInputController,
        only: [:new],
        as: :verify_contract_via_standard_json_input
      )

      resources(
        "/insights/:entity/verify-via-multi-part-files",
        AddressContractVerificationViaMultiPartFilesController,
        only: [:new],
        as: :verify_contract_via_multi_part_files
      )

      resources(
        "/insights/:entity/verify-vyper-contract",
        AddressContractVerificationVyperController,
        only: [:new],
        as: :verify_vyper_contract
      )

      resources(
        "/insights/:entity/read-contract",
        AddressReadContractController,
        only: [:index, :show],
        as: :read_contract
      )

      resources(
        "/insights/:entity/read-proxy",
        AddressReadProxyController,
        only: [:index, :show],
        as: :read_proxy
      )

      resources(
        "/insights/:entity/write-contract",
        AddressWriteContractController,
        only: [:index, :show],
        as: :write_contract
      )

      resources(
        "/insights/:entity/write-proxy",
        AddressWriteProxyController,
        only: [:index, :show],
        as: :write_proxy
      )

      resources(
        "/insights/:entity/token-transfers",
        AddressTokenTransferController,
        only: [:index],
        as: :token_transfers
      )

      resources("/insights/:entity/tokens", AddressTokenController, only: [:index], as: :token) do
        resources(
          "/insights/:entity/token-transfers",
          AddressTokenTransferController,
          only: [:index],
          as: :transfers
        )
      end

      resources(
        "/insights/:entity/token-balances",
        AddressTokenBalanceController,
        only: [:index],
        as: :token_balance
      )

      resources(
        "/insights/:entity/coin-balances",
        AddressCoinBalanceController,
        only: [:index],
        as: :coin_balance
      )

      resources(
        "/insights/:entity/coin-balances/by-day",
        AddressCoinBalanceByDayController,
        only: [:index],
        as: :coin_balance_by_day
      )
    end

    resources "/insights/:entity/token", Tokens.TokenController, only: [:show], as: :token do
      resources(
        "/insights/:entity/token-transfers",
        Tokens.TransferController,
        only: [:index],
        as: :transfer
      )

      resources(
        "/insights/:entity/read-contract",
        Tokens.ContractController,
        only: [:index],
        as: :read_contract
      )

      resources(
        "/insights/:entity/write-contract",
        Tokens.ContractController,
        only: [:index],
        as: :write_contract
      )

      resources(
        "/insights/:entity/read-proxy",
        Tokens.ContractController,
        only: [:index],
        as: :read_proxy
      )

      resources(
        "/insights/:entity/write-proxy",
        Tokens.ContractController,
        only: [:index],
        as: :write_proxy
      )

      resources(
        "/insights/:entity/token-holders",
        Tokens.HolderController,
        only: [:index],
        as: :holder
      )

      resources(
        "/insights/:entity/inventory",
        Tokens.InventoryController,
        only: [:index],
        as: :inventory
      )

      resources(
        "/insights/:entity/instance",
        Tokens.InstanceController,
        only: [:show],
        as: :instance
      ) do
        resources(
          "/insights/:entity/token-transfers",
          Tokens.Instance.TransferController,
          only: [:index],
          as: :transfer
        )

        resources(
          "/insights/:entity/metadata",
          Tokens.Instance.MetadataController,
          only: [:index],
          as: :metadata
        )

        resources(
          "/insights/:entity/token-holders",
          Tokens.Instance.HolderController,
          only: [:index],
          as: :holder
        )
      end
    end

    resources "/insights/:entity/tokens", Tokens.TokenController, only: [:show], as: :token_secondary do
      resources(
        "/insights/:entity/token-transfers",
        Tokens.TransferController,
        only: [:index],
        as: :transfer
      )

      resources(
        "/insights/:entity/read-contract",
        Tokens.ContractController,
        only: [:index],
        as: :read_contract
      )

      resources(
        "/insights/:entity/write-contract",
        Tokens.ContractController,
        only: [:index],
        as: :write_contract
      )

      resources(
        "/insights/:entity/read-proxy",
        Tokens.ContractController,
        only: [:index],
        as: :read_proxy
      )

      resources(
        "/insights/:entity/write-proxy",
        Tokens.ContractController,
        only: [:index],
        as: :write_proxy
      )

      resources(
        "/insights/:entity/token-holders",
        Tokens.HolderController,
        only: [:index],
        as: :holder
      )

      resources(
        "/insights/:entity/inventory",
        Tokens.InventoryController,
        only: [:index],
        as: :inventory
      )

      resources(
        "/insights/:entity/instance",
        Tokens.InstanceController,
        only: [:show],
        as: :instance
      ) do
        resources(
          "/insights/:entity/token-transfers",
          Tokens.Instance.TransferController,
          only: [:index],
          as: :transfer
        )

        resources(
          "/insights/:entity/metadata",
          Tokens.Instance.MetadataController,
          only: [:index],
          as: :metadata
        )

        resources(
          "/insights/:entity/token-holders",
          Tokens.Instance.HolderController,
          only: [:index],
          as: :holder
        )
      end
    end

    resources(
      "/insights/:entity/smart-contracts",
      SmartContractController,
      only: [:index, :show],
      as: :smart_contract
    )

    get("/insights/:entity/address-counters", AddressController, :address_counters)

    get("/insights/:entity/search", ChainController, :search)

    get("/insights/:entity/search-logs", AddressLogsController, :search_logs)

    get("/insights/:entity/search-results", SearchController, :search_results)

    get("/insights/:entity/search-verified-contracts", VerifiedContractsController, :search_verified_contracts)

    get("/insights/:entity/csv-export", CsvExportController, :index)

    get("/insights/:entity/transactions-csv", AddressTransactionController, :transactions_csv)

    get("/insights/:entity/token-autocomplete", ChainController, :token_autocomplete)

    get("/insights/:entity/token-transfers-csv", AddressTransactionController, :token_transfers_csv)

    get("/insights/:entity/internal-transactions-csv", AddressTransactionController, :internal_transactions_csv)

    get("/insights/:entity/logs-csv", AddressTransactionController, :logs_csv)

    get("/insights/:entity/chain-blocks", ChainController, :chain_blocks, as: :chain_blocks)

    get("/insights/:entity/token-counters", Tokens.TokenController, :token_counters)

    get("/insights/:entity/visualize/sol2uml", VisualizeSol2umlController, :index)

    get("/*path", PageNotFoundController, :index)
  end
end
