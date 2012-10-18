Fabricator(:parent_active_record_model) do
  transient :placeholder
  dynamic_field { |attrs| attrs[:placeholder] }
  nil_field nil
  number_field 5
  string_field 'content'
  false_field false
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

# ActiveRecord Objects
Fabricator(:division) do
  name "Division Name"
end

Fabricator(:squadron, :from => :division)

Fabricator(:company) do
  display 'for sure'
end
Fabricator(:startup, :from => :company)
