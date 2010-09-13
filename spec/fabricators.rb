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

Fabricator(:person) do
  first_name "John"
  last_name { Faker::Name.last_name }
  age { rand(100) }
  shoes(:count => 10) { |person, i| "shoe #{i}" }
  location
end

# ActiveRecord Objects
Fabricator(:division) do
  name "Division Name"
end

# Mongoid Documents
Fabricator(:author) do
  name 'George Orwell'
  books(:count => 4) do |author, i|
    Fabricate(:book, :title => "book title #{i}", :author => author)
  end
end

Fabricator(:hemingway, :from => :author) do
  name 'Ernest Hemingway'
end

Fabricator(:book) do
  title "book title"
end
