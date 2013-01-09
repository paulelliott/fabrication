Fabricator(:parent_sequel_model) do
  transient :placeholder
  dynamic_field { |attrs| attrs[:placeholder] }
  nil_field nil
  number_field 5
  string_field 'content'
  false_field false
  extra_fields { Hash.new }
  after_build do |object, transients|
    object.extra_fields[:transient_value] = transients[:placeholder]
  end
end

Fabricator(:parent_sequel_model_with_children, from: :parent_sequel_model) do
  child_sequel_models(count: 2)
end

Fabricator(:child_sequel_model) do
  number_field 10
end

Fabricator(:child_sequel_model_with_parent, from: :child_sequel_model) do
  parent_sequel_model
end
