$:.unshift(File.expand_path('../lib', File.dirname(__FILE__)))
$:.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'spec'
require 'spec/autorun'
require 'fabrication'
require 'ffaker'

Spec::Runner.configure do |config|
  config.before(:all) do
    Fabrication.clear_definitions
  end
end
