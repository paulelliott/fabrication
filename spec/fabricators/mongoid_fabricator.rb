if defined?(Mongoid)
  Fabricator(:parent_mongoid_document) do
    transient :placeholder, :transient_with_default => 'my custom value'
    dynamic_field { |attrs| attrs[:placeholder] }
    nil_field nil
    number_field 5
    string_field 'content'
    false_field false
    extra_fields { Hash.new }
    before_validation do |object, transients|
      object.extra_fields[:transient_value] = transients[:placeholder]
    end
  end

  Fabricator(:parent_mongoid_document_with_children, from: :parent_mongoid_document) do
    embedded_mongoid_documents(count: 2)
    after_create do |doc|
      2.times do
        doc.referenced_mongoid_documents << Fabricate(:referenced_mongoid_document)
      end
    end
  end

  Fabricator(:referenced_mongoid_document) do
    parent_mongoid_document
    number_field 10
  end

  Fabricator(:referenced_mongoid_document_with_parent, from: :referenced_mongoid_document) do
    parent_mongoid_document
  end

  Fabricator(:embedded_mongoid_document) do
    number_field 10
  end

  Fabricator(:embedded_mongoid_document_with_parent, from: :embedded_mongoid_document) do
    parent_mongoid_document
  end
end
