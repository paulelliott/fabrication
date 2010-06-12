$:.unshift(File.expand_path('../lib', File.dirname(__FILE__)))
$:.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'spec'
require 'spec/autorun'
require 'fabrication'
require 'ffaker'

class Person; attr_accessor :age, :first_name, :last_name end
