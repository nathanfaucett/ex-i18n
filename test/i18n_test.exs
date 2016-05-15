defmodule I18nTest do
  use ExUnit.Case
  doctest I18n

  test "should add translations to locale and translate keys" do
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

    e = try do
      I18n.add(:en, %{
        "test" => %{
          "two" => "this test three! %s"
        }
      })
    catch
      _, e -> e
    end
    assert e ==  %I18n.Error{
      message: "cannot override locale en translation with key test.two"
    }

    assert I18n.translate(:en, "test.one", []) == "this test one"
    assert I18n.translate(:en, "test.two", ["Hello, World!"]) == "this test two, Hello, World!"

    e = try do
      I18n.translate(:en, "test.three", [])
    catch
      _, e -> e
    end
    assert e ==  %I18n.Error{
      message: "missing translation for key test.three"
    }
  end
end
