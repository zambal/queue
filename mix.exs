defmodule Queue.MixProject do
  use Mix.Project

  def project do
    [
      app: :queue,
      version: "1.0.0",
      elixir: "~> 1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "Queue",
      source_url: "https://github.com/zambal/queue",
      docs: [
        # The main page in the docs
        main: "Queue",
        extras: ["README.md"]
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
