defmodule HoundTest do
  use ExUnit.Case
  use Hound.Helpers

  alias Hound.Element

  hound_session()

  test "the truth", meta do
    navigate_to("http://localhost:4000/hello")
    assert(String.contains? visible_page_text(), "Hello")
  end

  test "should take a screenshot" do
    navigate_to("http://localhost:4000/hello")
    body_html = find_element(:css, "body", 5)
    path = take_screenshot("screenshot.png")
    assert File.exists?(path)
  end

end
