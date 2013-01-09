Fabricator(:parent_active_record_model) do
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

Fabricator('namespaced/team') do
  name 'A Random Team'
end

Fabricator(:team_with_members_count, :from => 'namespaced/team') do
  members_count 7
end
