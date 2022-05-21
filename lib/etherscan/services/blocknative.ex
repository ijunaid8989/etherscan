defmodule Etherscan.Services.Blocknative do
  alias Etherscan.API.HTTP

  def add_to_watch(hashes) do
    hashes
    |> Task.async_stream(&do_send_request/1, max_concurrency: 10)
    |> Enum.to_list()
  end

  defp do_send_request(hash) do
    blocknative_api()
    |> HTTP.post(
      ["Content-Type": "application/json"],
      Jason.encode!(%{
        "apiKey" => blocknative_key(),
        "hash" => hash,
        "blockchain" => "ethereum",
        "network" => "main"
      })
    )
  end

  defp blocknative_api(), do: Application.get_env(:etherscan, :blocknative_api)

  defp blocknative_key(), do: Application.get_env(:etherscan, :blocknative_key)
end
