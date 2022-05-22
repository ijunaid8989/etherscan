defmodule EtherscanWeb.WatchController do
  use EtherscanWeb, :controller

  alias Etherscan.Services.Blocknative

  action_fallback EtherscanWeb.FallbackController

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"tx_ids" => tx_ids} = _params) do
    Blocknative.add_to_watch(tx_ids)

    conn
    |> put_status(200)
    |> render("show.json", message: "Hashes have been added to watch.")
  end

  def status(conn, params) do
    IO.inspect(params)

    conn
    |> put_status(:created)
    |> render("show.json", watch: %{})
  end
end
