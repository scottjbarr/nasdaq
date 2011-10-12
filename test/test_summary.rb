require 'test/test_helper'

class TestSummary < Test::Unit::TestCase

  include Nasdaq

  def setup
  end

  def test_should_have_path_for_symbol
    assert_equal "/symbol/mo", Summary.path("MO")
  end

  def test_should_have_uri_for_symbol
    uri = Summary.uri("MO")
    assert_equal URI::HTTP, uri.class
    assert_equal "http://#{SERVER}/symbol/mo", uri.to_s
  end

  def test_should_get_summary_for_symbol
    stub_get(Summary.uri("MO"), "mo_quote_and_summary.html")

    summary = Summary.for("MO")

    assert_equal 2071234000, summary.shares_outstanding
    assert_equal "MO", summary.symbol
    assert_equal "NYSE", summary.stock_exchange
  end

  def test_should_have_path_for_symbol_containing_forward_slash
    assert_equal "/symbol/brk-b", Summary.path("BRK/B")
  end
end
