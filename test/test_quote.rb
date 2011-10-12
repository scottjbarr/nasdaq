require 'test/test_helper'

class TestQuote < Test::Unit::TestCase

  include Nasdaq

  def setup
  end

  def test_should_have_path_for_symbol
    expected = "/aspx/NLS/NLSHandler.ashx?msg=Last&Symbol=KO&QESymbol=KO"
    assert_equal expected, Quote.path("KO")
  end

  def test_should_have_uri_for_symbol
    uri = Quote.uri("KO")
    assert_equal URI::HTTP, uri.class

    expected = "http://www.nasdaq.com#{Quote.path("KO")}"
    assert_equal expected, uri.to_s
  end

  def test_should_have_quote_for_symbol
    stub_get(Quote.uri("KO"), "ko.xml")

    quote = Quote.for("KO")

    assert_equal "KO", quote.symbol
    assert_equal 3491156, quote.consolidated_shares
    assert_equal 27.2, quote.high
    assert_equal 26.9, quote.low
    assert_equal "16:0", quote.market_close_time
    assert_equal "O", quote.market_status
    assert_equal 26.95, quote.previous_close
    assert_equal 27.16, quote.price
    assert_equal 35000, quote.refresh_time
    assert_equal "10/7/2011 11:49:49 AM", quote.server_time
    assert_equal 1646044, quote.tot_vol
    assert_equal "10/7/2011 11:49:49 AM", quote.trade_date
  end

  def test_should_have_open_market
    stub_get(Quote.uri("KO"), "ko.xml")

    quote = Quote.for("KO")

    assert quote.market_open?
  end

  def test_should_have_change
    stub_get(Quote.uri("KO"), "ko.xml")

    quote = Quote.for("KO")

    assert_in_delta 0.21, quote.change, 0.001
  end

  def test_should_have_path_for_symbol_with_forward_slash
    expected = "/aspx/NLS/NLSHandler.ashx?msg=Last&Symbol=BRK.B&QESymbol=BRK%2FB"
    assert_equal expected, Quote.path("BRK/B")
  end

end
