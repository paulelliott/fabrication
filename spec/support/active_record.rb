require 'active_record'

dbconfig = {
  :adapter => 'sqlite3',
  :database => ':memory:'
}

ActiveRecord::Base.establish_connection(dbconfig)
ActiveRecord::Migration.verbose = false

class TestMigration < ActiveRecord::Migration
  def self.up
    create_table :child_active_record_models, :force => true do |t|
      t.column :parent_active_record_model_id, :integer
      t.column :number_field, :integer
    end

    create_table :parent_active_record_models, :force => true do |t|
      t.column :before_save_value, :integer
      t.column :dynamic_field, :string
      t.column :dependent_dynamic_field, :string
      t.column :nil_field, :string
      t.column :number_field, :integer
      t.column :string_field, :string
      t.column :false_field, :boolean
    end

    create_table :companies, :force => true do |t|
      t.column :name, :string
      t.column :city, :string
      t.column :display, :string
    end

    create_table :divisions, :force => true do |t|
      t.column :name, :string
      t.references :company
    end

    create_table :namespaced_teams, :force => true do |t|
      t.column :name, :string
      t.column :members_count, :integer
      t.references :company
    end
  end

  def self.down
    drop_table :child_active_record_models
    drop_table :parent_active_record_models
    drop_table :companies
    drop_table :divisions
    drop_table :namespaced_teams
  end
end

class ChildActiveRecordModel < ActiveRecord::Base
  belongs_to :parent_active_record_model
end

class ParentActiveRecordModel < ActiveRecord::Base
  has_many :child_active_record_models
  attr_protected :number_field
  attr_accessor :extra_fields

  before_save do
    self.before_save_value = 11
  end
end

class Company < ActiveRecord::Base
  has_many :divisions

  attr_accessor :non_field
end

class Division < ActiveRecord::Base
  belongs_to :company
end

module Namespaced
  class Team < ActiveRecord::Base
    belongs_to :company, :class_name => Company
  end

  Team.table_name = :namespaced_teams
end
