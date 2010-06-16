# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'fabrication/version'

Gem::Specification.new do |s|
  s.name = "fabrication"
  s.version = Fabrication::VERSION

  s.authors = ["Paul Elliott"]
  s.email = ["paul@hashrocket.com"]
  s.description = "Fabrication is an object generation framework that lazily generated attributes as they are used"

  s.files = Dir.glob("{lib,spec}/**/*") + %w(README.markdown)

  s.homepage = "http://github.com/paulelliott/fabrication"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.3.6"
  s.summary = "Fabrication aims to provide a fast and simple solution for test object generation"

  s.add_development_dependency("rspec", [">= 1.2.9"])
  s.add_development_dependency("ffaker", [">= 0.4.0"])
  s.add_development_dependency("activerecord", [">= 2.3.5"])
  s.add_development_dependency("sqlite3-ruby", [">= 1.3.0"])
end
