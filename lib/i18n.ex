defmodule I18n do
  use Application
  use Supervisor


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
      throw RuntimeError.exception("key must be a String")
    end
    if Translations.has?(locale) == false do
      throw RuntimeError.exception("no translations for " <> locale <> " locale")
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
    translations = Translations.get(locale)
    new_translations = flatten_map(map)

    if Tipo.map?(translations) do
      Enum.each(Map.keys(new_translations), fn (key) ->
        if Map.has_key?(translations, key) do
          throw RuntimeError.exception(
            ExPrintf.sprintf(
              "cannot override locale %s translation with key %s",
              [locale, key]
            )
          )
        end
      end)
    end

    Translations.set(locale, new_translations)
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
      RuntimeError.exception("missing translation for key " <> key)
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
