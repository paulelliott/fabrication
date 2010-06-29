require 'spec_helper'

describe Fabrication do

  context 'static fields' do

    let(:person) do
      Fabricate(:person, :last_name => 'Awesome')
    end

    before(:all) do
      Fabricator(:person) do
        first_name 'Joe'
        last_name 'Schmoe'
        age 78
      end
    end

    it 'has the default first name' do
      person.first_name.should == 'Joe'
    end

    it 'has an overridden last name' do
      person.last_name.should == 'Awesome'
    end

    it 'has the default age' do
      person.age.should == 78
    end

    it 'generates a fresh object every time' do
      Fabricate(:person).should_not == person
    end

  end

  context 'block generated fields' do

    let(:person) do
      Fabricate(:person)
    end

    before(:all) do
      Fabricator(:person) do
        first_name { Faker::Name.first_name }
        last_name { Faker::Name.last_name }
        age { rand(100) }
        shoes(:count => 10) { |person, i| "shoe #{i}" }
      end
    end

    it 'has a first name' do
      person.first_name.should be
    end

    it 'has a last name' do
      person.last_name.should be
    end

    it 'has an age' do
      person.age.should be
    end

    it 'has 10 shoes' do
      person.shoes.should == (1..10).map { |i| "shoe #{i}" }
    end

  end

  context 'with the generation parameter' do

    before(:all) do
      Fabricator(:person) do
        first_name "Paul"
        last_name { |person| "#{person.first_name}#{person.age}" }
        age 60
      end
    end

    let(:person) { Fabricate(:person) }

    it 'evaluates the fields in order of declaration' do
      person.last_name.should == "Paul"
    end

  end

  context 'multiple instance' do

    let(:person1) { Fabricate(:person, :first_name => 'Jane') }
    let(:person2) { Fabricate(:person, :first_name => 'John') }

    before(:all) do
      Fabricator(:person) do
        first_name { Faker::Name.first_name }
        last_name { Faker::Name.last_name }
        age { rand(100) }
      end
    end

    it 'person1 is named Jane' do
      person1.first_name.should == 'Jane'
    end

    it 'person2 is named John' do
      person2.first_name.should == 'John'
    end

    it 'they have different last names' do
      person1.last_name.should_not == person2.last_name
    end

  end

  context 'with an active record object' do

    before(:all) { TestMigration.up }
    after(:all) { TestMigration.down }

    before do
      Fabricator(:company) do
        name { Faker::Company.name }
        divisions(:force => true, :count => 4) { Fabricate(:division) }
        after_create { |o| o.update_attribute(:city, "Jacksonville Beach") }
      end

      Fabricator(:division) do
        name "Awesome Division"
      end
    end

    let(:company) { Fabricate(:company, :name => "Hashrocket") }

    it 'generates field blocks immediately' do
      company.name.should == "Hashrocket"
    end

    it 'generates associations immediately when forced' do
      Division.find_all_by_company_id(company.id).count.should == 4
    end

    it 'overrides associations' do
      Fabricate(:company, :divisions => []).divisions.should == []
    end

    it 'executes after create blocks' do
      company.city.should == 'Jacksonville Beach'
    end

  end

  context 'with a mongoid document' do

    let(:author) do
      Fabricator(:author) do
        name "George Orwell"
        books(:count => 4) { |author, i| "book title #{i}" }
      end.fabricate
    end

    it "sets the author name" do
      author.name.should == "George Orwell"
    end

    it 'generates four books' do
      author.books.should == (1..4).map { |i| "book title #{i}" }
    end
  end

  context 'with a parent fabricator' do

    context 'and a previously defined parent' do

      let(:ernie) { Fabricate(:hemingway) }

      before(:all) do
        Fabricator(:author) do
          name 'George Orwell'
          books { ['1984'] }
        end

        Fabricator(:hemingway, :from => :author) do
          name 'Ernest Hemingway'
        end
      end

      it 'has the values from the parent' do
        ernie.books.should == ['1984']
      end

      it 'overrides specified values from the parent' do
        ernie.name.should == 'Ernest Hemingway'
      end

    end

    context 'and a class name as a parent' do

      before(:all) do
        Fabrication.clear_definitions
        Fabricator(:hemingway, :from => :author) do
          name 'Ernest Hemingway'
        end
      end

      let(:ernie) { Fabricate(:hemingway) }

      it 'has the name defined' do
        ernie.name.should == 'Ernest Hemingway'
      end

      it 'not have any books' do
        ernie.books.should be_nil
      end

    end

  end

  describe '.clear_definitions' do

    before(:all) do
      Fabricator(:author) {}
      Fabrication.clear_definitions
    end

    it 'should not generate authors' do
      lambda { Fabricate(:author) }.should raise_error(Fabrication::UnknownFabricatorError)
    end

  end

  context 'when generating from a non-existant fabricator' do

    before(:all) do
      Fabrication.clear_definitions
    end

    it 'throws an error' do
      lambda { Fabricate(:author) }.should raise_error(Fabrication::UnknownFabricatorError)
    end

  end

end
