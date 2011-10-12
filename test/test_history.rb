require 'test/test_helper'

class TestHistory < Test::Unit::TestCase

  include Nasdaq

  def setup
    # I don't want to repeat these long paths
    @path_mo_480 = "/ext/charts.dll?2-1-14-0-0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0-5480-03NA000000MO-&SF:4%7C5-WD=539-HT=395--XXCL-"
    @path_mo_001 = "/ext/charts.dll?2-1-14-0-0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0-5001-03NA000000MO-&SF:4%7C5-WD=539-HT=395--XXCL-"
  end

  def test_should_have_path_for_symbol
    assert_equal @path_mo_480, History.path("MO", 480)
  end

  def test_should_have_uri_for_symbol
    uri = History.uri("MO", 480)
    assert_equal URI::HTTP, uri.class
    assert_equal "http://#{CHART_SERVER}#{@path_mo_480}", uri.to_s
  end

  def test_should_have_uri_for_symbol_with_months_specified
    uri = History.uri("MO", 1)
    assert_equal URI::HTTP, uri.class
    assert_equal "http://#{CHART_SERVER}#{@path_mo_001}", uri.to_s
  end

  def test_should_hash_values
    ary = %w(10/10/2011 66.559998 66.93 66.010002 66.900002 5,880,196)

    expected = {
      :date => Date.parse("2011-10-10"),
      :open => 66.559998,
      :high => 66.93,
      :low => 66.010002,
      :close => 66.900002,
      :volume => 5880196
    }

    assert_equal expected, History.hash_values(ary)
  end

  def test_should_parse_history
    stub_get(History.uri("MO", 480), "mo_history_1_month.csv")

    ary = History.for("MO")

    assert_equal 21, ary.size

    history = ary.first
    assert_equal 27.63, history.close
    assert_equal Date.parse("2011-10-10"), history.date
    assert_equal 27.8, history.high
    assert_equal 27.42, history.low
    assert_equal 27.73, history.open
    assert_equal 11507640, history.volume

    history = ary.last
    assert_equal 26.54, history.close
    assert_equal Date.parse("12 Sep 2011"), history.date
    assert_equal 26.57, history.high
    assert_equal 26.01, history.low
    assert_equal 26.06, history.open
    assert_equal 15121910, history.volume
  end

  def test_should_have_path_for_symbol_with_forward_slash
    expected = "/ext/charts.dll?2-1-14-0-0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0%7C0,0,0,0,0-5001-03NA000000BRK'B-&SF:4%7C5-WD=539-HT=395--XXCL-"
    assert_equal expected, History.path("BRK/B", 1)
  end

end
