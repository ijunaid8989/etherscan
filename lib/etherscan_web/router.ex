defmodule EtherscanWeb.Router do
  use EtherscanWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", EtherscanWeb do
    pipe_through :api
  end
end
