defmodule Excoin.Mixfile do
  use Mix.Project

  def project do
    [app: :excoin,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test, "coveralls.post": :test],
   ]
  end


  def application do
    [applications: [:logger],
     mod: {Excoin, []}]
  end

  defp deps do
    [
      {:poison, "~> 1.5"},
      {:excoveralls, "~> 0.4.3"}
    ]
  end
end
