Fabricator(:parent_sequel_model) do
  transient :placeholder
  dynamic_field { |attrs| attrs[:placeholder] }
  nil_field nil
  number_field 5
  string_field 'content'
end

Fabricator(:parent_sequel_model_with_children, from: :parent_sequel_model) do
  after_create do |parent|
    2.times do
      Fabricate(:child_sequel_model, :parent_sequel_model => parent)
    end
  end
end

Fabricator(:child_sequel_model) do
  number_field 10
end
