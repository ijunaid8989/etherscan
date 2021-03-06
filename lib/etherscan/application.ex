defmodule Etherscan.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      EtherscanWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Etherscan.PubSub},
      Etherscan.Queue.Worker,
      {Finch,
       name: Etherscan.API.HTTP,
       pools: %{
         slack_api() => [size: 32, count: 8],
         blocknative_api() => [size: 32, count: 8]
       }},
      # Start the Endpoint (http/https)
      EtherscanWeb.Endpoint
      # Start a worker by calling: Etherscan.Worker.start_link(arg)
      # {Etherscan.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Etherscan.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EtherscanWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp slack_api(), do: Application.get_env(:etherscan, :slack_api)

  defp blocknative_api(), do: Application.get_env(:etherscan, :blocknative_api)
end
