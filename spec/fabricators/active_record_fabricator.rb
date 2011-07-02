Fabricator(:parent_active_record_model) do
  collection_field(:count => 2) do |parent, i|
    Fabricate(:child_active_record_model, :parent => parent, :number_field => i)
  end
  dynamic_field { 'dynamic content' }
  nil_field nil
  number_field 5
  string_field 'content'
end

Fabricator(:child_active_record_model)

# ActiveRecord Objects
Fabricator(:division) do
  name "Division Name"
end

Fabricator(:squadron, :from => :division)

Fabricator(:company)
Fabricator(:startup, :from => :company)
