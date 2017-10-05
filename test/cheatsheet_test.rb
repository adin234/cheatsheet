require 'test_helper'
require 'cheatsheet'

class CheatsheetTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Cheatsheet::VERSION
  end

  def test_client_success
    assert_match (/Jollibee/), Cheatsheet::Client.fetch(["ph-food-delivery"])
  end

  def test_client_failure
    assert_raises(CheatSheetClientException) { Cheatsheet::Client.fetch(["us-food-delivery"]) }
  end

  def test_client_search_finds
    assert_includes Cheatsheet::Client.fetch(["-a", "xpath"]), 'xpath'
  end

  def test_client_search_doesnt_find
    assert_raises(CheatSheetClientException) { Cheatsheet::Client.fetch(["-a", "xmen"]) }
  end

  def test_client_search_finds_correctly
    refute_includes Cheatsheet::Client.fetch(["-a", "xpath"]), 'react'
  end

  def test_client_invalid_result
  end

  def test_client_rendering
  end

end
