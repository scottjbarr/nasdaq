module Nasdaq

  class History < Hashie::Dash

    include Base

    property :date
    property :open
    property :high
    property :low
    property :close
    property :volume

    def self.path(symbol, months)
      months = "%03i" % months

      params = "2-1-14-0-0,0,0,0,0|"

      # there are 40 of these "zero" blocks
      params += 40.times.map { "0,0,0,0,0|" }.join()

      params += "0,0,0,0,0-5#{months}-03NA000000#{symbol}-"
      params += "&SF:4|5-WD=539-HT=395--XXCL-"

      "/ext/charts.dll?#{URI.encode(params)}"
    end

    def self.uri(symbol, months)
      URI.parse("http://#{CHART_SERVER}#{path(symbol, months)}")
    end

    def self.for(symbol, months = 480)
      uri = uri(symbol, months)
      http = Net::HTTP.new(uri.host, uri.port)
      response = http.get(uri.to_s)

      parse(response.body)
    end

    def self.parse(body)
      ary = body.split("\r\n")
      ary.shift

      ary.map { |r|
        values = r.split("\t").map { |d| d.strip }
        History.new(hash_values(values))
      }
    end

    def self.hash_values(ary)
      hash = {}
      [:date, :open, :high, :low, :close, :volume].each { |k|
        hash[k] = cast_value(k, ary.shift)
      }
      hash
    end

    def self.cast_value(key, value)
      if key == :date
        Date.strptime(value, '%m/%d/%Y')
      elsif key == :volume
        value.gsub(',', '').to_i
      else
        value.to_f
      end
    end

  end
end
