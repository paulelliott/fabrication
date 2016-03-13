if defined?(DataMapper)
  DataMapper.setup(:default, "sqlite3::memory:")

  class ParentDataMapperModel
    include DataMapper::Resource

    property :id, Serial
    property :before_save_value, Integer
    property :dynamic_field, String
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

    # no validation callback in DataMapper
    def before_validation_value
      1
    end
  end

  class ChildDataMapperModel
    include DataMapper::Resource

    property :id, Serial
    property :number_field, Integer

    alias persisted? saved?

    belongs_to :parent_data_mapper_model
  end

  DataMapper.auto_migrate!
end
