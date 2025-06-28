defmodule Quex.MixProject do
  use Mix.Project

  def project do
    [
      app: :quex,
      version: "1.0.1",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Package
      name: "Quex",
      source_url: "https://github.com/zambal/quex",
      description: """
      An efficient implementation of double ended fifo queues
      """,
      package: [
        name: :quex,
        files: ~w(lib test mix.exs README.md LICENSE),
        maintainers: ["Vincent Siliakus"],
        licenses: ["Apache-2.0"],
        links: %{"Github" => "https://github.com/zambal/quex"}
      ]
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:ex_doc, "~> 0.38.2", only: :dev, runtime: false, warn_if_outdated: true}
    ]
  end
end
