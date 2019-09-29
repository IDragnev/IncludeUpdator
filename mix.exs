defmodule IncludeUpdator.MixProject do
  use Mix.Project

  def project do
    [
      app: :include_updator,
      escript: escript_config(),
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      dir_walker: "~> 0.0.7"
    ]
  end

  defp escript_config do
    [
      main_module: IncludeUpdator.CLI
    ]
  end

end
