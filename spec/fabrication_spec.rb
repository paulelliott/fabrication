require 'spec_helper'

describe Fabrication do

  context 'static fields' do

    let(:person) { Fabricate(:person, :last_name => 'Awesome') }

    it 'has the default first name' do
      person.first_name.should == 'John'
    end

    it 'has an overridden last name' do
      person.last_name.should == 'Awesome'
    end

    it 'generates a fresh object every time' do
      Fabricate(:person).should_not == person
    end

  end

  context 'block generated fields' do

    let(:person) { Fabricate(:person) }

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

    let(:person) do
      Fabricate(:person) do
        first_name "Paul"
        last_name { |person| "#{person.first_name}#{person.age}" }
      end
    end

    it 'evaluates the fields in order of declaration' do
      person.last_name.should == "Paul"
    end

  end

  context 'multiple instance' do

    let(:person1) { Fabricate(:person, :first_name => 'Jane') }
    let(:person2) { Fabricate(:person, :first_name => 'John') }

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

  context 'with a specified class name' do

    let(:someone) { Fabricate(:someone) }

    before do
      Fabricator(:someone, :class_name => :person) do
        first_name "Paul"
      end
    end

    it 'generates the person as someone' do
      someone.first_name.should == "Paul"
    end

  end

  context 'with an active record object' do

    before(:all) do
      Fabricator(:company) do
        name { Faker::Company.name }
        divisions!(:count => 4) { Fabricate(:division) }
        after_create { |o| o.update_attribute(:city, "Jacksonville Beach") }
      end

      Fabricator(:other_company, :from => :company) do
        divisions(:count => 2) { Fabricate(:division) }
      end
    end

    before { TestMigration.up }
    after { TestMigration.down }

    let(:company) { Fabricate(:company, :name => "Hashrocket") }

    it 'generates field blocks immediately' do
      company.name.should == "Hashrocket"
    end

    it 'generates associations immediately when forced' do
      Division.find_all_by_company_id(company.id).count.should == 4
    end

    it 'executes after create blocks' do
      company.city.should == 'Jacksonville Beach'
    end

    it 'overrides associations' do
      Fabricate(:company, :divisions => []).divisions.should == []
    end

    it 'overrides inherited associations' do
      Fabricate(:other_company).divisions.count.should == 2
      Division.count.should == 2
    end

  end

  context 'with a mongoid document' do

    let(:author) { Fabricate(:author) }

    it "sets the author name" do
      author.name.should == "George Orwell"
    end

    it 'generates four books' do
      author.books.map(&:title).should == (1..4).map { |i| "book title #{i}" }
    end
  end

  context 'with a parent fabricator' do

    context 'and a previously defined parent' do

      let(:ernie) { Fabricate(:hemingway) }

      it 'has the values from the parent' do
        ernie.books.count.should == 4
      end

      it 'overrides specified values from the parent' do
        ernie.name.should == 'Ernest Hemingway'
      end

    end

    context 'and a class name as a parent' do

      let(:greyhound) { Fabricate(:greyhound) }

      it 'has the breed defined' do
        greyhound.breed.should == 'greyhound'
      end

      it 'does not have a name' do
        greyhound.name.should be_nil
      end

    end

  end

  describe '.clear_definitions' do

    before(:all) do
      Fabrication.clear_definitions
    end

    after(:all) do
      Fabrication::Support.find_definitions
    end

    it 'should not generate authors' do
      Fabrication.fabricators.has_key?(:author).should be_false
    end

  end

  context 'when defining a fabricator twice' do

    before(:all) do
      Fabricator(:author) {}
    end

    it 'throws an error' do
      lambda { Fabricator(:author) {} }.should raise_error(Fabrication::DuplicateFabricatorError)
    end

  end

  context 'when generating from a non-existant fabricator' do

    it 'throws an error' do
      lambda { Fabricate(:your_mom) }.should raise_error(Fabrication::UnknownFabricatorError)
    end

  end

  context 'defining a fabricator without a block' do

    before(:all) do
      class Widget; end
      Fabricator(:widget)
    end

    it 'works fine' do
      Fabricate(:widget).should be
    end

  end

  describe ".fabricators" do

    let(:author) { Fabricator(:author) }
    let(:book) { Fabricator(:book) }

    before(:all) do
      Fabrication.clear_definitions
      author; book
    end

    after(:all) do
      Fabrication::Support.find_definitions
    end

    it "returns the two fabricators" do
      Fabrication.fabricators.should == {:author => author, :book => book}
    end

  end

  describe "Fabricate with a block" do

    let(:person) do
      Fabricate(:person) do
        first_name "Paul"
        last_name { "Elliott" }
      end
    end

    it 'uses the class matching the passed-in symbol' do
      person.kind_of?(Person).should be_true
    end

    it 'has the correct first_name' do
      person.first_name.should == 'Paul'
    end

    it 'has the correct last_name' do
      person.last_name.should == 'Elliott'
    end

    it 'has the correct age' do
      person.age.should be_nil
    end

  end

  describe "Fabricate.attributes_for" do

    let(:person) do
      Fabricate.attributes_for(:person, :first_name => "John", :last_name => "Smith")
    end

    it 'has the first name as a parameter' do
      person['first_name'].should == "John"
    end

    it 'has the last name as a parameter' do
      person[:last_name].should == "Smith"
    end

  end

end
