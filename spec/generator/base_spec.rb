require 'spec_helper'

describe Fabrication::Generator::Base do

  let(:person) do
    Fabrication::Generator::Base.new(Person) do
      first_name 'Some'
      last_name { Faker::Name.last_name }
      age 40
    end.generate({:first_name => 'Body'})
  end

  it 'generates an instance' do
    person.instance_of?(Person).should be_true
  end

  it 'generates the first name immediately' do
    person.instance_variable_get(:@first_name).should == 'Body'
  end

  it 'generates the last name immediately' do
    person.instance_variable_get(:@last_name).should be
  end

  it 'generates the age immediately' do
    person.instance_variable_get(:@age).should == 40
  end

end
