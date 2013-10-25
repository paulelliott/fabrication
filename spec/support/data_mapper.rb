require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, "sqlite3::memory:")

class ParentDataMapperModel
  include DataMapper::Resource

  property :id, Serial
  property :before_save_value, Integer
  property :dynamic_field, String
  property :dependent_dynamic_field, String
  property :nil_field, String
  property :number_field, Integer
  property :string_field, String
  property :false_field, Boolean
  attr_accessor :extra_fields

  has n, :child_data_mapper_models

  alias persisted? saved?

  before :save do
    self.before_save_value = 11
  end
end

class ChildDataMapperModel
  include DataMapper::Resource

  property :id, Serial
  property :number_field, Integer

  alias persisted? saved?

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
