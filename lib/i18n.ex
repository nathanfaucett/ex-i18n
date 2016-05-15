defmodule I18n do
  use Application
  use Supervisor


  defmodule Error do
    defexception [:message]

    def exception(msg), do: %I18n.Error{
        message: msg
      }
  end

  defmodule Translations do
    def start_link() do
        Agent.start_link(fn -> %{} end, name: __MODULE__)
    end

    def get(locale) do
        Map.get(Agent.get(__MODULE__, fn(translations) -> translations end), locale)
    end
    def has?(locale) do
        Map.has_key?(Agent.get(__MODULE__, fn(translations) -> translations end), locale)
    end
    def set(locale, map) do
        Agent.update(__MODULE__, fn(translations) ->
            if Map.has_key?(translations, locale) do
              Map.put(translations, locale, Map.merge(Map.get(translations, locale), map))
            else
              Map.put(translations, locale, map)
            end
        end)
    end
  end

  def translate(locale, key, args) do
    if Tipo.string?(key) == false do
      raise "(locale, key, [, ...args]) key must be a String"
    end
    if Translations.has?(locale) == false do
      raise "(locale, key, [, ...args]) no translations for " <> locale <> " locale"
    end

    translations = Translations.get(locale)
    if Map.has_key?(translations, key) do
      ExPrintf.sprintf(Map.get(translations, key), args)
    else
      missing_translation(key)
    end
  end
  def translate(locale, key), do: translate(locale, key, [])

  def add(locale, map) do
    Translations.set(locale, flatten_map(map))
  end

  defp flatten_map(map) do
    Enum.reduce(Map.keys(map), %{}, fn (k, m) ->
      v = Map.get(map, k)

      if Tipo.map?(v) do
        Map.merge(m, Enum.reduce(Map.keys(flatten_map(v)), %{}, fn (sub_k, sub_m) ->
          Map.put(sub_m, k <> "." <> sub_k, Map.get(v, sub_k))
        end))
      else
        Map.put(m, k, v)
      end
    end)
  end

  defp missing_translation(key) do
    if Mix.env == :prod || Mix.env == :test do
      I18n.Error.exception("i18n(locale, key) missing translation for key " <> key)
    else
      "--" <> key <> "--"
    end
  end

  def start(_type, _args) do
    Supervisor.start_link(__MODULE__, [])
  end
  def init([]) do
    children = [
      worker(Translations, [], restart: :temporary)
    ]
    supervise(children, strategy: :one_for_one)
  end
end
