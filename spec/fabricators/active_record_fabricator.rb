if defined?(ActiveRecord)
  Fabricator(:parent_active_record_model) do
    transient :placeholder, transient_with_default: 'my custom value'
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

  Fabricator(:parent_active_record_model_with_children, from: :parent_active_record_model) do
    child_active_record_models(count: 2)
  end

  Fabricator(:child_active_record_model) do
    number_field 10
  end

  Fabricator(:child_active_record_model_with_parent, from: :child_active_record_model) do
    parent_active_record_model
  end
end
