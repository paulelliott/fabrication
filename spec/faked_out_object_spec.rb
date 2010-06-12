require 'spec_helper'

describe Fabrication do

  let(:person) do
    Fabricate(:person)
  end

  before(:all) do
    Fabricator(:person) do
      first_name { Faker::Name.first_name }
      last_name { Faker::Name.last_name }
      age { rand(100) }
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

end
