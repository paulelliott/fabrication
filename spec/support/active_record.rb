if defined?(ActiveRecord)
  dbconfig = {
    :adapter => 'sqlite3',
    :database => ':memory:'
  }

  ActiveRecord::Base.establish_connection(dbconfig)
  ActiveRecord::Migration.verbose = false

  migrationBaseClass = ActiveRecord.respond_to?(:version) && ActiveRecord.version.to_s >= "5.1.0" ?
      ActiveRecord::Migration[5.1] : ActiveRecord::Migration

  class TestMigration < migrationBaseClass
    def self.up
      create_table :child_active_record_models, :force => true do |t|
        t.column :parent_active_record_model_id, :integer
        t.column :number_field, :integer
      end

      create_table :parent_active_record_models, :force => true do |t|
        t.column :before_validation_value, :integer, null: false, default: 0
        t.column :before_save_value, :integer
        t.column :dynamic_field, :string
        t.column :nil_field, :string
        t.column :number_field, :integer
        t.column :string_field, :string
        t.column :false_field, :boolean
      end
    end

    def self.down
      drop_table :child_active_record_models
      drop_table :parent_active_record_models
    end
  end

  class ChildActiveRecordModel < ActiveRecord::Base
    belongs_to :parent_active_record_model
  end

  class ParentActiveRecordModel < ActiveRecord::Base
    has_many :child_active_record_models
    attr_protected :number_field if respond_to?(:attr_protected)
    attr_accessor :extra_fields

    before_validation do
      self.before_validation_value += 1
    end

    before_save do
      self.before_save_value = 11
    end
  end
end
