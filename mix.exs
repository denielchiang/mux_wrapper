defmodule MuxWrapper.MixProject do
  use Mix.Project

  def project do
    [
      app: :mux_wrapper,
      version: "0.1.0",
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
      maintainers: [" Deniel "],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/denielchiang/mux_wrapper"}
    ]
  end

  defp aliases do
    [c: "compile"]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Database
      {:ecto, "~> 3.5"},

      # Mux
      {:mux, "~> 1.9.0"}
    ]
  end
end
