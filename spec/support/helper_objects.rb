class Person
  attr_accessor :age, :first_name, :last_name, :shoes
end

class Dog
  attr_accessor :name, :breed
end

Fabricator(:person) do
  first_name "John"
  last_name { Faker::Name.last_name }
  age { rand(100) }
  shoes(:count => 10) { |person, i| "shoe #{i}" }
end

Fabricator(:greyhound, :from => :dog) do
  breed "greyhound"
end
