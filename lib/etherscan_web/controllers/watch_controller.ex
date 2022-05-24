defmodule EtherscanWeb.WatchController do
  use EtherscanWeb, :controller

  alias Etherscan.Queue.Worker

  action_fallback EtherscanWeb.FallbackController

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"tx_ids" => tx_ids} = _params) do
    Worker.add_to_queue(tx_ids)

    conn
    |> put_status(200)
    |> render("show.json", message: "Hashes have been added to watch.")
  end

  @spec status(Plug.Conn.t(), map) :: Plug.Conn.t()
  def status(conn, params) do
    Worker.verify_hash_status(params)
    send_resp(conn, :ok, "")
  end
end
