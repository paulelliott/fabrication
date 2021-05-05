Fabrication::Transform.define(:parent_active_record_model, lambda { |string_field|
  ParentActiveRecordModel.find_by_string_field(string_field)
})
Fabrication::Transform.define(:parent_mongoid_document, lambda { |string_field|
  ParentMongoidDocument.where(string_field: string_field).one
})
Fabrication::Transform.define(:parent_sequel_model, lambda { |string_field|
  ParentSequelModel.where(string_field: string_field).first
})
