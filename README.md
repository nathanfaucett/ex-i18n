# I18n [![Build Status](https://travis-ci.org/nathanfaucett/ex-i18n.svg?branch=master)](https://travis-ci.org/nathanfaucett/ex-i18n)

i18n locale translations helpers

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add i18n to your list of dependencies in `mix.exs`:

        def deps do
          [{:i18n, "~> 0.0.1"}]
        end

  2. Ensure i18n is started before your application:

        def application do
          [applications: [:i18n]]
        end

```elixir

I18n.add(:en, %{
  "home" => %{
    "welcome" => "Welcome Home, %s!"
  }
})

I18n.translate(:en, "home.welcome", ["Nathan"])

```
