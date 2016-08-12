defmodule I18n.Mixfile do
  use Mix.Project

  def project do
    [app: :i18n,
     version: "0.0.2",
     description: description,
     package: package,
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:tipo, :exprintf],
    mod: {I18n, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:tipo, "~> 0.0.3"},
    {:exprintf, "~> 0.1.6"}]
  end

  defp description do
   """
   i18n locale translations helpers
   """
 end

  defp package do
    [# These are the default files included in the package
      name: :i18n,
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Nathan Faucett"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/nathanfaucett/ex-i18n",
        "Docs" => "https://github.com/nathanfaucett/ex-i18n"
      }
    ]
  end
end
