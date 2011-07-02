class ParentRubyObject
  attr_accessor \
    :collection_field,
    :dynamic_field,
    :nil_field,
    :number_field,
    :string_field

  def persisted?; true end
end

class ChildRubyObject
  attr_accessor \
    :parent,
    :number_field

  def persisted?; true end
end

Fabricator(:parent_ruby_object) do
  collection_field(:count => 2, :fabricator => :child_ruby_object)
  dynamic_field { 'dynamic content' }
  nil_field nil
  number_field 5
  string_field 'content'
end

Fabricator(:child_ruby_object) do
  number_field 10
end

# Plain Ruby Objects
Fabricator(:awesome_object, :from => :object)

Fabricator(:dog)
Fabricator(:greyhound, :from => :dog) do
  breed "greyhound"
  locations(:count => 2)
end

Fabricator(:location) do
  lat 35
  lng 40
end
Fabricator(:interesting_location, :from => :location)

Fabricator(:person) do
  first_name "John"
  last_name { Faker::Name.last_name }
  age { rand(100) }
  shoes(:count => 10) { |person, i| "shoe #{i}" }
  location
end

Fabricator(:child, :from => :person) do
  after_build { |child| child.first_name = 'Johnny' }
  after_build { |child| child.age = 10 }
end

Fabricator(:senior, :from => :child) do
  after_build { |senior| senior.age *= 7 }
end

Fabricator(:city) do
  on_init { init_with('Boulder', 'CO') }
end

Fabricator("Something::Amazing") do
  stuff "cool"
end

Fabricator(:sequencer) do
  simple_iterator { sequence(:simple_iterator) }
  param_iterator  { sequence(:param_iterator, 9) }
  block_iterator  { sequence(:block_iterator) { |i| "block#{i}" } }
end

Fabricator("Sequencer::Namespaced") do
  iterator { sequence(:iterator) }
end
