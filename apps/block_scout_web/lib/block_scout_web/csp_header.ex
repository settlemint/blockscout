defmodule BlockScoutWeb.CSPHeader do
  @moduledoc """
  Plug to set content-security-policy with websocket endpoints
  """

  alias Phoenix.Controller
  alias Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    config = Application.get_env(:block_scout_web, __MODULE__)
    google_url = "https://www.google.com"
    czilladx_url = "https://request-global.czilladx.com"
    coinzillatag_url = "https://coinzillatag.com"
    trustwallet_url = "https://raw.githubusercontent.com/trustwallet/assets/"
    walletconnect_urls = "wss://*.bridge.walletconnect.org https://registry.walletconnect.org/data/wallets.json"
    json_rpc_url = Application.get_env(:block_scout_web, :json_rpc)

    Controller.put_secure_browser_headers(conn, %{
      "content-security-policy" => "\
      connect-src 'self' #{websocket_endpoints(conn)} wss://*.bridge.walletconnect.org/ http://onprem.127.0.0.1.nip.io/ https://*.settlemint.com/ http://onprem.settlemint.local/ https://*.settlemint.local/ ws://onprem.127.0.0.1.nip.io/ wss://*.settlemint.com/ https://request-global.czilladx.com/ https://raw.githubusercontent.com/trustwallet/assets/ https://registry.walletconnect.org/data/wallets.json https://*.poa.network;\
      default-src 'self' https://*.settlemint.com/;\
        script-src 'self' 'unsafe-inline' 'unsafe-eval' #{coinzillatag_url} #{google_url} https://www.gstatic.com;\
        style-src 'self' 'unsafe-inline' 'unsafe-eval' http://fonts.googleapis.com https://fonts.googleapis.com;\
        img-src 'self' * data:;\
        media-src 'self' * data:;\
        font-src 'self' 'unsafe-inline' 'unsafe-eval' https://fonts.gstatic.com data:;\
        frame-src 'self' 'unsafe-inline' 'unsafe-eval' #{czilladx_url} #{google_url};\
        frame-ancestors 'self' http://onprem.settlemint.local/;\
        manifest-src 'self' https://*.settlemint.com/ http://onprem.settlemint.local/;\
      "
    })
  end

  defp websocket_endpoints(conn) do
    host = Conn.get_req_header(conn, "host")
    "ws://#{host} wss://#{host}"
  end
end
