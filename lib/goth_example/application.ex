defmodule Router do
  use Plug.Router
  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "Hello, World!")
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end

defmodule GothExample.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    require Logger

    port = System.get_env("PORT", "4000") |> String.to_integer()
    Logger.info("starting on port #{port}")

    Logger.info(inspect(Goth.Token.for_scope("https://www.googleapis.com/auth/cloud-platform")))

    children = [
      {Plug.Cowboy, plug: Router, scheme: :http, port: port}
    ]

    opts = [strategy: :one_for_one, name: GothExample.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
