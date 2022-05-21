defmodule Etherscan.Services.Slack do
  alias Etherscan.API.HTTP

  @spec send_hash_status(map) ::
          {:error, %{:__exception__ => true, :__struct__ => atom, optional(atom) => any}}
          | {:ok, Finch.Response.t()}
  def send_hash_status(%{
        "status" => status,
        "hash" => hash,
        "timeStamp" => timestamp,
        "system" => system
      }) do
    (slack_api() <> "/" <> slack_key())
    |> HTTP.post(
      ["Content-Type": "application/json"],
      Jason.encode!(%{
        "text" => "Hash: #{hash}\nStatus: #{status}\nTimestamp: #{timestamp}\nSystem: #{system}"
      })
    )
  end

  defp slack_api(), do: Application.get_env(:etherscan, :slack_api)

  defp slack_key(), do: Application.get_env(:etherscan, :slack_key)
end
