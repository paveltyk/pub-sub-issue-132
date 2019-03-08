defmodule PubSub.MyChannel do
  use GenServer

  def start_link(_args) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    Redix.PubSub.subscribe(PubSub.Connection, "my-channel", self())
  end

  @impl true
  def handle_info(:die, state) do
    {:ok} = {:error}
    {:noreply, state}
  end

  @impl true
  def handle_info({:redix_pubsub, _pubsub, _ref, :subscribed, %{channel: channel}}, state) do
    IO.inspect(channel, label: "#{inspect(self())} The pub/sub listener is subscribed to")
    {:noreply, state}
  end

  @impl true
  def handle_info({:redix_pubsub, _pubsub, _ref, :message, %{payload: message}}, state) do
    IO.inspect(message, label: "#{inspect(self())} Received message")
    {:noreply, state}
  end

  @impl true
  def handle_info(_, state) do
    {:noreply, state}
  end
end
