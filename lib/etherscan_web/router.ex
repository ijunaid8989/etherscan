defmodule EtherscanWeb.Router do
  use EtherscanWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", EtherscanWeb do
    pipe_through :api

    post "/add_to_watch", WatchController, :create

    post "/get_watch_status", WatchController, :status
  end
end
