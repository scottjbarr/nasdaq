require "scottjbarr-nasdaq/version"
require 'net/http'
require 'cgi'
require 'uri'
require 'nokogiri'
require 'hashie'
require 'active_support/core_ext/string/inflections'

Dir.glob(File.dirname(__FILE__) + '/scottjbarr-nasdaq/*') { |file| require file }

module Nasdaq
  SERVER = "www.nasdaq.com"
  CHART_SERVER = "charting.nasdaq.com"
end
