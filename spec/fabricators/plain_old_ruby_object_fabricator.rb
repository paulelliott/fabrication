Fabricator(:parent_ruby_object) do
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

Fabricator(:parent_ruby_object_with_children, from: :parent_ruby_object) do
  child_ruby_objects(:count => 2)
end

Fabricator(:child_ruby_object) do
  number_field 10
end

Fabricator(:child_ruby_object_with_parent, from: :child_ruby_object) do
  parent_ruby_object
end

# Plain Ruby Objects
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

Fabricator(:troublemaker)

Fabricator(:persistable)
