require 'mongoid'

Mongoid.configure do |config|
  config.allow_dynamic_fields = true
  config.master = Mongo::Connection.new.db("fabrication_test")
end

def clear_mongodb
  Mongoid.master.collections.select {|c| c.name !~ /system/ }.each(&:drop)
end

class ChildMongoidDocument
  include Mongoid::Document

  field :number_field

  referenced_in :parent, :class_name => 'ParentMongoidDocument'
end

class ParentMongoidDocument
  include Mongoid::Document

  field :dynamic_field
  field :nil_field
  field :number_field
  field :string_field

  references_many :collection_field, :class_name => 'ChildMongoidDocument', :inverse_of => :parent
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
  field :position

  embedded_in :author, :inverse_of => :books

  before_create :set_position

  def set_position
    books = self.author.books
    if books.present? && books.count > 0
      self.position = books.last.position + 1
    else
      self.position = 1
    end
  end
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
