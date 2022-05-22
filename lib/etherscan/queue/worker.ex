defmodule Etherscan.Queue.Worker do
  use GenServer

  require Logger

  alias Etherscan.Services.Blocknative

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(_opt) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @spec init(map()) :: {:ok, any, {:continue, :init_queue}}
  def init(state) do
    {:ok, state, {:continue, :init_queue}}
  end

  @spec handle_continue(:init_queue, map) ::
          {:noreply, %{:clock => reference, :queue => :queue.queue(any), optional(any) => any}}
  def handle_continue(:init_queue, state) do
    Logger.info("Initiated Queue with clock.")
    clock = Process.send_after(self(), :send_requests, 10_000)

    {:noreply,
     Map.put(state, :queue, :queue.from_list([]))
     |> Map.put(:clock, clock)}
  end

  def handle_cast({:add_to_queue, hashes}, %{queue: queue} = state) do
    Logger.info("Added hashes to Queue.")
    {:noreply, Map.put(state, :queue, merge_hashes(hashes, queue))}
  end

  def handle_info(:send_requests, %{queue: queue, clock: clock} = state) do
    Process.cancel_timer(clock)

    {queue, hashes} = take_from_queue(queue, 10)

    if length(hashes) > 0 do
      Logger.info("Sent hashes requests to Blocknative.")
      Blocknative.add_to_watch(hashes)
    end

    clock = Process.send_after(self(), :send_requests, 10_000)

    {:noreply,
     Map.put(state, :clock, clock)
     |> Map.put(:queue, queue)}
  end

  @spec add_to_queue(list(String.t())) :: :ok
  def add_to_queue(hashes) do
    GenServer.cast(__MODULE__, {:add_to_queue, hashes})
  end

  defp merge_hashes(hashes, queue) do
    [hashes | :queue.to_list(queue)]
    |> List.flatten()
    |> :queue.from_list()
  end

  defp take_from_queue(queue, amount) do
    Enum.reduce_while(1..amount, {queue, []}, fn _index, {queue, list} = _acc ->
      case :queue.out(queue) do
        {{:value, value}, rest} ->
          {:cont, {rest, [value | list]}}

        {:empty, rest} ->
          {:halt, {rest, list}}
      end
    end)
  end
end
