require 'net/http'
require 'cgi'
require 'uri'
require 'nokogiri'
require 'hashie'
require 'active_support/core_ext/string/inflections'

module Nasdaq

  class Quote < Hashie::Dash

    property :symbol
    property :tot_vol
    property :high
    property :low
    property :price
    property :consolidated_shares
    property :server_time
    property :refresh_time
    property :market_status
    property :market_close_time
    property :previous_close
    property :trade_date

    INTEGER_FIELDS = %w(consolidated_shares refresh_time tot_vol)
    DECIMAL_FIELDS = %w(high low previous_close price)
    # DATE_FIELDS = %w(server_time trade_date)

    def market_open?
      market_status == "O"
    end

    def self.path(symbol)
      data = {
        :msg => "Last",
        :Symbol => symbol.upcase,
        :QESymbol => symbol.upcase
      }
      path = "/aspx/NLS/NLSHandler.ashx?#{get_form_data(data)}"
    end

    def self.uri(symbol)
      URI.parse("http://#{SERVER}#{path(symbol)}")
    end

    def self.for(symbol)
      uri = uri(symbol)
      http = Net::HTTP.new(uri.host, uri.port)
      response = http.get(uri.to_s)

      # p resp.status
      hash = parse(response.body)
      hash[:symbol] = symbol

      hash = cast_values(hash)
      Quote.new(hash)
    end

    def self.cast_values(hash)
      hash.each_pair do |k, v|
        if INTEGER_FIELDS.include?(k)
          hash[k] = v.to_i
        elsif DECIMAL_FIELDS.include?(k)
          hash[k] = v.to_f
        end
      end

      hash
    end

    # Convert a hash to an escaped query string
    def self.get_form_data(params)
      params.reduce("") { |m, v| m += "#{v[0]}=#{CGI.escape(v[1].to_s)}&" }.chop
    end

    def self.parse(body)
      xml = Nokogiri::XML(body) do |config|
        config.options = Nokogiri::XML::ParseOptions::STRICT | Nokogiri::XML::ParseOptions::NOENT | Nokogiri::XML::ParseOptions::NOBLANKS
      end

      hash = {}

      xml.xpath('//DocumentElement/Last').children.each do |node|
        hash[convert_name(node.name)] = node.text
      end

      hash
    end

    def self.convert_name(name)
      name = name.underscore

      if name == "previousclose"
        name = "previous_close"
      elsif name == "tradedate"
        name = "trade_date"
      end

      name
    end

  end

end
