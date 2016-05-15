defmodule I18nTest do
  use ExUnit.Case
  doctest I18n

  test "should" do
    I18n.add(:en, %{
      "test" => %{
        "one" => "this test one"
      }
    })
    I18n.add(:en, %{
      "test" => %{
        "two" => "this test two, %s"
      }
    })

    assert I18n.translate(:en, "test.one", []) == "this test one"
    assert I18n.translate(:en, "test.two", ["Hello, World!"]) == "this test two, Hello, World!"

    e = try do
      I18n.translate(:en, "test.three", [])
    catch
      (what, value) -> {what, value}
    end

    assert e ==  %I18n.Error{
      message: "i18n(locale, key) missing translation for key test.three"
    }
  end
end
