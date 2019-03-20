defmodule Hello.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  import Supervisor.Spec, warn: false


  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Hello.Repo, []),
      # Start the endpoint when the application starts
      HelloWeb.Endpoint,
      # Starts a worker by calling: Hello.Worker.start_link(arg)
      # {Hello.Worker, arg},
      supervisor(Hello.BoardChannel.Supervisor, []),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Hello.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    HelloWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
