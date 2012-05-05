Fabricator(:parent_data_mapper_model) do
  dynamic_field { 'dynamic content' }
  nil_field nil
  number_field 5
  string_field 'content'
end

Fabricator(:parent_data_mapper_model_with_children, from: :parent_data_mapper_model) do
  child_data_mapper_models(count: 2)
end

Fabricator(:child_data_mapper_model) do
  number_field 10
end

# DataMapper Objects
Fabricator(:movie) do
  name "One Night in Paris"
end

Fabricator(:porn, :from => :movie)

Fabricator(:store)
Fabricator(:xxx_movies, :from => :store)
