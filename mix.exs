defmodule MuxWrapper.MixProject do
  use Mix.Project

  def project do
    [
      app: :mux_wrapper,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Mux API wrapper for Kamaitachi",
      aliases: aliases(),
      package: package()
    ]
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
