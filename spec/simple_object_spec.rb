require 'spec_helper'

describe Fabrication do

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

  it 'has a first name' do
    person.first_name.should == 'Joe'
  end

  it 'has a last name' do
    person.last_name.should == 'Awesome'
  end

  it 'has an age' do
    person.age.should == 78
  end

  it 'generates a fresh object every time' do
    Fabricate(:person).should_not == person
  end

end
