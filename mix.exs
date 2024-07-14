defmodule NostrumTemplate.MixProject do
  use Mix.Project

  def project do
    [
      app: :nostrum_template,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :ecto],
      mod: {NostrumTemplate.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dotenv_parser, "~> 2.0"},
      # Nostrum
      {:nostrum, github: "Kraigie/nostrum"},
      {:nostrum_utils, github: "MiniAppleTheApple/nostrum_utils"},
      # Ecto 
      {:ecto, "~> 3.11"},
      {:ecto_sql, "~> 3.11"},
      {:postgrex, "~> 0.17.0"},
    ]
  end
end
