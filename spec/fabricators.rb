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

# ActiveRecord Objects
Fabricator(:division) do
  name "Division Name"
end

Fabricator(:squadron, :from => :division)

Fabricator(:company)
Fabricator(:startup, :from => :company)


# Mongoid Documents
Fabricator(:author) do
  name 'George Orwell'
  books(:count => 4) do |author, i|
    Fabricate.build(:book, :title => "book title #{i}", :author => author)
  end
end

Fabricator(:hemingway, :from => :author) do
  name 'Ernest Hemingway'
end

Fabricator(:book) do
  title "book title"
end

Fabricator(:publishing_house)
Fabricator(:book_promoter)
Fabricator(:professional_affiliation)
