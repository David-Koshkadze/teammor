defmodule Teammor.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TeammorWeb.Telemetry,
      Teammor.Repo,
      {DNSCluster, query: Application.get_env(:teammor, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Teammor.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Teammor.Finch},
      # Start a worker by calling: Teammor.Worker.start_link(arg)
      # {Teammor.Worker, arg},
      # Start to serve requests, typically the last entry
      TeammorWeb.Endpoint,
      {AshAuthentication.Supervisor, [otp_app: :teammor]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Teammor.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TeammorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
