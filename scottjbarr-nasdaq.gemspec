# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "scottjbarr-nasdaq/version"

Gem::Specification.new do |s|
  s.name        = "scottjbarr-nasdaq"
  s.version     = Nasdaq::VERSION
  s.authors     = ["Scott Barr"]
  s.email       = ["scottjbarr@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Scrape quotes from NASDAQ}
  s.description = %q{Scrape quotes from NASDAQ}

  s.rubyforge_project = "scottjbarr-nasdaq"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake"
  s.add_development_dependency "test-unit"
  s.add_development_dependency "mocha"
  s.add_development_dependency "fakeweb"
  s.add_runtime_dependency "nokogiri"
  s.add_runtime_dependency "activesupport"
  s.add_runtime_dependency "hashie"
end
