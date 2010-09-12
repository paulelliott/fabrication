require 'mongoid'

Mongoid.configure do |config|
  config.allow_dynamic_fields = true
  config.master = Mongo::Connection.new.db("fabrication_test")
end

def clear_mongodb
  Mongoid.master.collections.select {|c| c.name !~ /system/ }.each(&:drop)
end

Rspec.configure do |config|
  config.before(:all) do
    clear_mongodb
  end
end

class Author
  include Mongoid::Document

  embeds_many :books

  field :name
  field :handle
end

class Book
  include Mongoid::Document

  field :title

  embedded_in :author, :inverse_of => :books
end
