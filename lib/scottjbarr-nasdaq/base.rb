module Nasdaq
  module Base

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def get(uri)
        http = Net::HTTP.new(uri.host, uri.port)
        http.get(uri.to_s)
      end

      # Convert a hash to an escaped query string
      def get_form_data(params)
        params.reduce("") { |m, v| m += "#{v[0]}=#{CGI.escape(v[1].to_s)}&" }.chop
      end

    end

  end
end
