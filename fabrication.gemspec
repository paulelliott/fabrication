# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'fabrication/version'

Gem::Specification.new do |s|
  s.name = "fabrication"
  s.version = Fabrication::VERSION

  s.authors = ["Paul Elliott"]
  s.email = ["paul@hashrocket.com"]
  s.description = "Fabrication is an object generation framework for ActiveRecord, Mongoid, and Sequel. It has a sensible syntax and lazily generates ActiveRecord associations!"

  s.homepage = "http://fabricationgem.org"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.3.7"
  s.summary = "Fabrication provides a simple solution for test object generation."

  s.add_development_dependency("activerecord")
  s.add_development_dependency("bson_ext",     ["~> 1.3.1"])
  s.add_development_dependency("cucumber")
  s.add_development_dependency("ffaker")
  s.add_development_dependency("fuubar")
  s.add_development_dependency("fuubar-cucumber")
  s.add_development_dependency("mongoid",      ["~> 2.1.3"])
  s.add_development_dependency("rake")
  s.add_development_dependency("rspec")
  s.add_development_dependency("sequel")
  s.add_development_dependency("sqlite3")

  s.files = Dir.glob("{lib,spec}/**/*") + %w(LICENSE README.markdown Rakefile)
  s.require_path = 'lib'
end
