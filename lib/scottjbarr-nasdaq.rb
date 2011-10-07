require "scottjbarr-nasdaq/version"

Dir.glob(File.dirname(__FILE__) + '/scottjbarr-nasdaq/*') { |file| require file }

module Nasdaq
  SERVER = "www.nasdaq.com"
end
