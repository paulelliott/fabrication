require 'dm-active_model'
require 'dm-core'
require 'dm-migrations'

# DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, "sqlite3::memory:")

class ParentDataMapperModel
  include DataMapper::Resource

  property :id, Serial
  property :before_save_value, Integer
  property :dynamic_field, String
  property :nil_field, String
  property :number_field, Integer
  property :string_field, String

  has n, :child_data_mapper_models

  before :save do
    self.before_save_value = 11
  end
end

class ChildDataMapperModel
  include DataMapper::Resource

  property :id, Serial
  property :number_field, Integer

  belongs_to :parent_data_mapper_model
end

class Store
  include DataMapper::Resource

  property :id, Serial
  property :name, String

  has n, :movies

  attr_accessor :non_field
end

class Movie
  include DataMapper::Resource

  property :id, Serial
  property :name, String

  belongs_to :store
end

DataMapper.auto_migrate!
