if defined?(Mongoid)
  Mongoid.load!("spec/support/mongoid.yml", :test)

  Mongoid.logger.level = Logger::ERROR
  Mongo::Logger.logger.level = Logger::ERROR if defined?(Mongo)

  def clear_mongodb
    Mongoid::Config.purge!
  end

  class ParentMongoidDocument
    include Mongoid::Document
    include Mongoid::Attributes::Dynamic if defined?(Mongoid::Attributes::Dynamic)

    field :before_validation_value, default: 0
    field :before_save_value
    field :dynamic_field
    field :nil_field
    field :number_field
    field :string_field
    field :false_field, type: Boolean
    field :extra_fields, type: Hash

    has_many :referenced_mongoid_documents
    embeds_many :embedded_mongoid_documents

    attr_protected :number_field if respond_to?(:attr_protected)

    before_validation do
      self.before_validation_value += 1
    end

    before_save do
      self.before_save_value = 11
    end
  end

  class ReferencedMongoidDocument
    include Mongoid::Document

    field :number_field

    belongs_to :parent_mongoid_document
  end

  class EmbeddedMongoidDocument
    include Mongoid::Document

    field :number_field

    embedded_in :parent_mongoid_document

    delegate :id, to: :parent_mongoid_document, prefix: true
  end
else
  def clear_mongodb; end
end
