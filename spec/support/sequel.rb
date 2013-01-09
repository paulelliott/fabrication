require 'sequel'

DB = Sequel.sqlite # in memory
Sequel.extension :migration
Sequel::Migrator.run(DB, 'spec/support/sequel_migrations', :current => 0)

def clear_sequel_db
  ParentSequelModel.truncate
  ChildSequelModel.truncate
end

class ChildSequelModel < Sequel::Model
  many_to_one :parent_sequel_model

  def persisted?; !new? end
end

class ParentSequelModel < Sequel::Model
  one_to_many :child_sequel_models
  set_restricted_columns :string_field
  attr_accessor :extra_fields

  def persisted?; !new? end

  def before_save
    self.before_save_value = 11
    super
  end
end
