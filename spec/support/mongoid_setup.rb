Mongoid.configure do |config|
  config.allow_dynamic_fields = true
  config.master = Mongo::Connection.new.db("fabrication_test")
end

class Author
  include Mongoid::Document
  field :name
  field :books, :type => Array
end
