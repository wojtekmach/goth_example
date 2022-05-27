defmodule GothExample.MixProject do
  use Mix.Project

  def project do
    [
      app: :goth_example,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {GothExample.Application, []}
    ]
  end

  defp deps do
    [
      {:goth, "~> 1.2.0"}
    ]
  end
end
