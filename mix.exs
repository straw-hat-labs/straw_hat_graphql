defmodule StrawHat.GraphQL.MixProject do
  use Mix.Project

  @name :straw_hat_graphql
  @version "0.2.2"
  @elixir_version "~> 1.5"
  @source_url "https://github.com/straw-hat-team/straw_hat_graphql"

  def project do
    production? = Mix.env() == :prod

    [
      name: "StrawHat.GraphQL",
      description: "StrawHat GraphQL Utils",
      app: @name,
      version: @version,
      deps: deps(),
      elixir: @elixir_version,
      start_permanent: production?,
      aliases: aliases(),
      test_coverage: test_coverage(),
      preferred_cli_env: cli_env(),
      package: package(),
      docs: docs()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:straw_hat, "~> 0.4"},
      {:absinthe, "~> 1.4"},
      {:jason, "~> 1.1"},
      {:ecto, "~> 3.0", optional: true},

      # Tools
      {:dialyxir, ">= 0.0.0", only: [:dev], runtime: false},
      {:credo, ">= 0.0.0", only: [:dev, :test], runtime: false},
      {:excoveralls, ">= 0.0.0", only: [:test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: [:dev], runtime: false},
      {:inch_ex, ">= 0.0.0", only: [:dev], runtime: false}
    ]
  end

  defp test_coverage do
    [tool: ExCoveralls]
  end

  defp cli_env do
    [
      "coveralls.html": :test,
      "coveralls.json": :test
    ]
  end

  defp aliases do
    [
      test: ["test --trace"]
    ]
  end

  defp package do
    [
      name: @name,
      files: [
        "lib",
        "mix.exs",
        "README*",
        "LICENSE*"
      ],
      maintainers: ["Yordis Prieto"],
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp docs do
    [
      main: "readme",
      homepage_url: @source_url,
      source_ref: "v#{@version}",
      source_url: @source_url,
      extras: ["README.md"]
    ]
  end
end
