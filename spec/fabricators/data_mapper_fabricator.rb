if defined?(DataMapper)
  Fabricator(:parent_data_mapper_model) do
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

  Fabricator(:parent_data_mapper_model_with_children, from: :parent_data_mapper_model) do
    child_data_mapper_models(count: 2)
  end

  Fabricator(:child_data_mapper_model) do
    number_field 10
  end

  Fabricator(:child_data_mapper_model_with_parent, from: :child_data_mapper_model) do
    parent_data_mapper_model
  end
end
