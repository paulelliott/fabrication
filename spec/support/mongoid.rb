require 'mongoid'

Mongoid.configure do |config|
  config.allow_dynamic_fields = true
  config.master = Mongo::Connection.new.db("fabrication_test")
end

def clear_mongodb
  Mongoid.master.collections.select {|c| c.name !~ /system/ }.each(&:drop)
end

class ParentMongoidDocument
  include Mongoid::Document

  field :before_save_value
  field :dynamic_field
  field :nil_field
  field :number_field
  field :string_field

  references_many :referenced_mongoid_documents

  before_save do
    self.before_save_value = 11
  end
end

class ReferencedMongoidDocument
  include Mongoid::Document

  field :number_field

  referenced_in :parent_mongoid_document
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

  referenced_in :professional_affiliation
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

  references_many :publishing_houses
end
