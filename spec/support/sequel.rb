if defined?(Sequel)
  DB = Sequel.sqlite # in memory
  Sequel.extension :migration
  Sequel::Migrator.run(DB, 'spec/support/sequel_migrations', :current => 0)
  Sequel::Model.strict_param_setting = true

  def clear_sequel_db
    ParentSequelModel.truncate
    ChildSequelModel.truncate
  end

  class ChildSequelModel < Sequel::Model
    many_to_one :parent_sequel_model

    def persisted?; !new? end
  end

  class ParentSequelModel < Sequel::Model
    plugin :class_table_inheritance, key: :kind, alias: :parent_sequel_models

    one_to_many :child_sequel_models

    attr_accessor :extra_fields

    def persisted?; !new? end

    def before_validation
      self.before_validation_value ||= 0
      self.before_validation_value += 1
      super
    end

    def before_save
      self.before_save_value = 11
      super
    end
  end

  class InheritedSequelModel < ParentSequelModel; end
end
