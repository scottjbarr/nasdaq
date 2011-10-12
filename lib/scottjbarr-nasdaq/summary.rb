module Nasdaq

  # The Summary class collects the summary information that NASDAQ provides.
  # This data is recalculated often. I am currently only interested in the
  # shares_outstanding value, so most of the data is ignored.
  class Summary < Hashie::Dash

    include Base

    property :symbol
    property :stock_exchange
    property :shares_outstanding

    def self.path(symbol)
      "/symbol/#{escape_symbol(symbol)}"
    end

    def self.uri(symbol)
      URI.parse("http://#{SERVER}#{path(symbol)}")
    end

    def self.for(symbol)
      response = get(uri(symbol))
      parse(response.body)
    end

    def self.parse(body)
      doc = Nokogiri::HTML.parse(body)

      # parse the symbol and stock exchange
      symbol_details = doc.css("#sq_symbol-info")
      symbol = symbol_details.children.first.content.split(" ").first
      stock_exchange = symbol_details.children.last.content.split(" ").last

      # get the data table
      table_data = get_table_data(doc.css("table[@class='datatable1_qn']"))
      shares_outstanding = table_data[11].gsub(/[^-.0-9]/, '').to_i

      hash = {
        :symbol => symbol,
        :stock_exchange => stock_exchange,
        :shares_outstanding => shares_outstanding
      }

      Summary.new(hash)
    end

    def self.get_table_data(table)
      data = []

      table.children.each_with_index do |tr, i|
        tr.children.each_with_index do |child, j|
          if child.name == 'td'
            data << child.children.first.content.gsub("\n", "").strip
          end
        end
      end

      # delete the "labels" from the data
      data.delete_if { |d| d[-1, 1] == ":" }

      data
    end

    def self.escape_symbol(symbol)
      symbol.downcase.gsub('/', '-')
    end

  end

end
