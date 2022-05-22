defmodule EtherscanWeb.WatchView do
  use EtherscanWeb, :view

  def render("show.json", %{message: message}) do
    %{message: message}
  end
end
