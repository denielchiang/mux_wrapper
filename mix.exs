defmodule MuxWrapper.MixProject do
  use Mix.Project

  def project do
    [
      app: :mux_wrapper,
      version: "0.1.4",
      elixir: "~> 1.11",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      name: "Mux Wrapper",
      aliases: aliases(),
      package: package(),
      source_url: "https://github.com/denielchiang/mux_wrapper"
    ]
  end

  defp description() do
    "A Mux API Wrapper to convert API resonponse to embedded schema"
  end

  defp package do
    [
      name: "mux_wrapper",
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*),
      maintainers: [" Deniel "],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/denielchiang/mux_wrapper"}
    ]
  end

  defp aliases do
    [
      c: "compile",
      "check.linter": ["credo --strict"]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Database
      {:ecto, "~> 3.5"},

      # Doc
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},

      # Mux
      {:mux, "~> 1.9.0"},

      # Linting
      {:credo, "~> 1.5", only: [:dev, :test], override: true},
      {:credo_envvar, "~> 0.1.4", only: [:dev, :test], runtime: false},
      {:credo_naming, "~> 1.0", only: [:dev, :test], runtime: false},

      # Test coverage
      {:excoveralls, "~> 0.13.4"}
    ]
  end
end
