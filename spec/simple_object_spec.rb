require 'spec_helper'

class Person; attr_accessor :age, :first_name, :last_name end

describe Fabrication do

  let(:person) do
    Fabricate(:person, :first_name => 'Joe', :last_name => 'Awesome', :age => 78)
  end

  before(:all) do
    Fabricator(:person) do
      first_name 'Joe'
      last_name 'Schmoe'
      age 78
    end
  end

  it 'has a first name' do
    person.first_name.should == 'Joe'
  end

  it 'has a last name' do
    person.last_name.should == 'Schmoe'
  end

  it 'has an age' do
    person.age.should == 78
  end

  it 'generates a fresh object every time' do
    Fabricate(:person).should_not == person
  end

end
