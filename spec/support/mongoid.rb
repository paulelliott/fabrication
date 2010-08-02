require 'mongoid'

Mongoid.configure do |config|
  config.allow_dynamic_fields = true
  config.master = Mongo::Connection.new.db("fabrication_test")
end

def clear_mongodb
  Mongoid.master.collections.select {|c| c.name !~ /system/ }.each(&:drop)
end

Spec::Runner.configure do |config|
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

Fabricator(:author) do
  name 'George Orwell'
  books(:count => 4) do |author, i|
    Fabricate(:book, :title => "book title #{i}", :author => author)
  end
end

Fabricator(:hemingway, :from => :author) do
  name 'Ernest Hemingway'
end

Fabricator(:book) do
  title "book title"
end
