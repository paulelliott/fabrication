require 'spec_helper'

describe Fabrication do

  context 'static fields' do

    let(:person) { Fabricate(:person, :last_name => 'Awesome') }
    let(:location) { Fabricate(:location) }
    let(:dog) do
      Fabricate(:dog) do
        name nil
      end
    end

    it 'has the default first name' do
      person.first_name.should == 'John'
    end

    it 'has an overridden last name' do
      person.last_name.should == 'Awesome'
    end

    it 'generates a fresh object every time' do
      Fabricate(:person).should_not == person
    end

    it "has the latitude" do
      location.lat.should == 35
    end

    it "has the longitude" do
      location.lng.should == 40
    end

    it "handles nil values" do
      dog.name.should be_nil
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

  context 'when the class requires a constructor' do
    subject do
      Fabricate(:city) do
        on_init { init_with('Jacksonville Beach', 'FL') }
      end
    end

    its(:city)  { should == 'Jacksonville Beach' }
    its(:state) { should == 'FL' }
  end

  context "when referring to other fabricators" do

    let(:person) { Fabricate(:person) }

    it "has the latitude" do
      person.location.lat.should == 35
    end

    it "has the longitude" do
      person.location.lng.should == 40
    end

    context "with a count" do

      context "of one" do

        let(:greyhound) do
          Fabricate(:greyhound) do
            locations(:count => 1)
          end
        end

        it "should have one location" do
          greyhound.locations.size.should == 1
          greyhound.locations.first.lat.should == 35
          greyhound.locations.first.lng.should == 40
        end

      end

      context "of two" do

        let(:greyhound) do
          Fabricate(:greyhound) do
            locations(:count => 2)
          end
        end

        it "should have two locations" do
          greyhound.locations.size.should == 2
          greyhound.locations.each do |loc|
            loc.lat.should == 35
            loc.lng.should == 40
          end
        end

      end

    end

  end

  context 'with the generation parameter' do

    let(:person) do
      Fabricate(:person, :first_name => "Paul") do
        last_name { |person| "#{person.first_name}#{person.age}" }
        age 50
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

    before { TestMigration.up }
    after  { TestMigration.down }

    before(:all) do
      Fabricator(:company) do
        name { Faker::Company.name }
        divisions!(:count => 4)
        non_field { "hi" }
        after_create { |o| o.update_attribute(:city, "Jacksonville Beach") }
      end

      Fabricator(:other_company, :from => :company) do
        divisions(:count => 2)
        after_build { |o| o.name = "Crazysauce" }
      end
    end

    let(:company) { Fabricate(:company, :name => "Hashrocket") }
    let(:other_company) { Fabricate(:other_company) }

    it 'generates field blocks immediately' do
      company.name.should == "Hashrocket"
    end

    it 'generates associations immediately when forced' do
      Division.find_all_by_company_id(company.id).count.should == 4
    end

    it 'generates non-database backed fields immediately' do
      company.instance_variable_get(:@non_field).should == 'hi'
    end

    it 'executes after build blocks' do
      other_company.name.should == 'Crazysauce'
    end

    it 'executes after create blocks' do
      company.city.should == 'Jacksonville Beach'
    end

    it 'overrides associations' do
      Fabricate(:company, :divisions => []).divisions.should == []
    end

    it 'overrides inherited associations' do
      other_company.divisions.count.should == 2
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

  context 'with multiple callbacks' do
    let(:child) { Fabricate(:child) }

    it "runs the first callback" do
      child.first_name.should == "Johnny"
    end

    it "runs the second callback" do
      child.age.should == 10
    end
  end

  context 'with multiple, inherited callbacks' do
    let(:senior) { Fabricate(:senior) }

    it "runs the parent callbacks first" do
      senior.age.should == 70
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
      Fabrication::Fabricator.schematics.has_key?(:author).should be_false
    end

  end

  context 'when defining a fabricator twice' do

    it 'throws an error' do
      lambda { Fabricator(:author) {} }.should raise_error(Fabrication::DuplicateFabricatorError)
    end

  end

  context "when defining a fabricator for a class that doesn't exist" do

    it 'throws an error' do
      lambda { Fabricator(:your_mom) }.should raise_error(Fabrication::UnfabricatableError)
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

  describe "Fabricate with a block" do

    let(:person) do
      Fabricate(:person) do
        age nil
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

    it 'has the fabricator provided attributes' do
      person[:shoes].length.should == 10
    end

  end

end
