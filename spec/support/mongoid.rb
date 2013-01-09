require 'mongoid'

Mongoid.load!("spec/support/mongoid.yml", :test)

def clear_mongodb
  Mongoid::Config.purge!
end

class ParentMongoidDocument
  include Mongoid::Document

  field :before_save_value
  field :dynamic_field
  field :nil_field
  field :number_field
  field :string_field
  field :false_field, type: Boolean
  field :extra_fields, type: Hash

  has_many :referenced_mongoid_documents
  embeds_many :embedded_mongoid_documents

  attr_protected :number_field

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

class PublishingHouse
  include Mongoid::Document

  belongs_to :professional_affiliation
  embeds_many :book_promoters

  field :name
end

class BookPromoter
  include Mongoid::Document

  embedded_in :publishing_house

  field :name
end

class ProfessionalAffiliation
  include Mongoid::Document

  has_many :publishing_houses
end
