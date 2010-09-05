class Dog
  attr_accessor :name, :breed, :locations
end

class Location
  attr_accessor :lat, :lng
end

class Person
  attr_accessor :age, :first_name, :last_name, :shoes, :location
end

Fabricator(:greyhound, :from => :dog) do
  breed "greyhound"
  locations(:count => 2)
end

Fabricator(:location) do
  lat 35
  lng 40
end

Fabricator(:person) do
  first_name "John"
  last_name { Faker::Name.last_name }
  age { rand(100) }
  shoes(:count => 10) { |person, i| "shoe #{i}" }
  location
end
