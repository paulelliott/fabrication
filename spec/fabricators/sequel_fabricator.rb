Fabricator(:parent_sequel_model) do
  dynamic_field { 'dynamic content' }
  nil_field nil
  number_field 5
  string_field 'content'
  after_create do |parent|
    (1..2).each do |i|
      Fabricate(:child_sequel_model, :parent => parent, :number_field => i)
    end
  end
end

Fabricator(:child_sequel_model)
