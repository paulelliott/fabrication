# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'fabrication/version'

Gem::Specification.new do |s|
  s.name = "fabrication"
  s.version = Fabrication::VERSION
  s.license = "MIT"

  s.authors = ["Paul Elliott"]
  s.email = ["paul@hashrocket.com"]
  s.description = "Fabrication is an object generation framework for ActiveRecord, Mongoid, DataMapper, Sequel, or any other Ruby object."

  s.homepage = "http://fabricationgem.org"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.3.7"
  s.summary = "Fabrication provides a simple solution for test object generation."

  s.required_ruby_version = '>= 1.9.3'

  s.files = Dir.glob("lib/**/*") + %w(LICENSE README.markdown Rakefile)
  s.require_path = 'lib'
end
