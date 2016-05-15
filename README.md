# I18n

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

props = %{
  "username" => %{
    :validations => [I18n.string],
    :required => true
  },
  "password" => %{
    :validations => [PropType.requires("username"), I18n.string, min_length(6)],
    :required => true
}

```
