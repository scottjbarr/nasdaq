require 'test/unit'
require 'lib/scottjbarr-nasdaq'
require 'mocha'
require 'fakeweb'

class Test::Unit::TestCase

  # Read and return the contents of a fixture file.
  #
  def fixture_file(name)
    IO.read("test/fixtures/#{name}")
  end

  FakeWeb.allow_net_connect = false

  def stub_get(url, filename, status = nil)
    options = {:body => fixture_file(filename)}
    options.merge!({:status => status}) unless status.nil?

    FakeWeb.register_uri(:get, url.to_s, options)
  end

end
