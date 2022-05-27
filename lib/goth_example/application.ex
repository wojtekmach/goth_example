defmodule GothExample.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    require Logger
    Logger.info("start")

    IO.inspect(Goth.Token.for_scope("https://www.googleapis.com/auth/cloud-platform"))

    children = []
    opts = [strategy: :one_for_one, name: GothExample.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
