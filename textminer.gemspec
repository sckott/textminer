# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'textminer/version'

Gem::Specification.new do |s|
  s.name        = 'textminer'
  s.version     = Textminer::VERSION
  s.date        = '2015-11-25'
  s.summary     = "Interact with Crossref's Text and Data mining API"
  s.description = "Search Crossref's search API for full text content, and get full text content."
  s.authors     = "Scott Chamberlain"
  s.email       = 'myrmecocystus@gmail.com'
  s.homepage    = 'http://github.com/sckott/textminer'
  s.licenses    = 'MIT'

  s.files = `git ls-files -z`.split("\x0").reject {|f| f.match(%r{^(test|spec|features)/}) }
  s.require_paths = ["lib"]

  s.bindir      = 'bin'
  s.executables = ['tm']

  s.add_development_dependency "bundler", '~> 1.6'
  s.add_development_dependency "rake", '~> 10.4'
  s.add_development_dependency "test-unit", '~> 3.1'
  s.add_development_dependency "oga", '~> 1.2'
  s.add_development_dependency "simplecov", '~> 0.10'
  s.add_development_dependency "codecov", '~> 0.1'

  s.add_runtime_dependency 'serrano', '~> 0.1.1'
  s.add_runtime_dependency 'httparty', '~> 0.13'
  s.add_runtime_dependency 'thor', '~> 0.19'
  s.add_runtime_dependency 'json', '~> 1.8'
  s.add_runtime_dependency 'launchy', '~> 2.4', '>= 2.4.2'
  s.add_runtime_dependency 'pdf-reader','~> 1.3'
end
