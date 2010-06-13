require 'spec_helper'

describe Fabrication do

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

end
