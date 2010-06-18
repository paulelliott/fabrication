$:.unshift(File.expand_path('../lib', File.dirname(__FILE__)))
$:.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'spec'
require 'spec/autorun'
require 'fabrication'
require 'ffaker'
require 'active_record'
require 'mongoid'

Spec::Runner.configure do |config|
  config.before(:all) do
    Author.delete_all
  end
end
