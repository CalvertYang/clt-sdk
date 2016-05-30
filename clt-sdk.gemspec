# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'clt/version'

Gem::Specification.new do |spec|
  spec.name          = "clt-sdk"
  spec.version       = Clt::VERSION
  spec.authors       = ["Calvert"]
  spec.email         = [""]

  spec.summary       = "Basic API client for President Collect Payment Service."
  spec.description   = ""
  spec.homepage      = "https://github.com/CalvertYang/clt-sdk"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri", "~> 1.6"
  spec.add_dependency "nori", "~> 2.6"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 11.1"

  spec.required_ruby_version = ">= 2.1.5"
end
