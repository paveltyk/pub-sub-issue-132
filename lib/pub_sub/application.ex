defmodule PubSub.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      %{
        id: PubSub.Connection,
        start: {Redix.PubSub, :start_link, ["redis://localhost:6379", [name: PubSub.Connection]]},
        restart: :permanent,
        shutdown: 5_000,
        type: :worker
      },
      PubSub.MyChannel
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PubSub.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
