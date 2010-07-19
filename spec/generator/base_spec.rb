require 'spec_helper'

describe Fabrication::Generator::Base do

  let(:schematic) do
    Fabrication::Schematic.new do
      first_name 'Some'
      last_name { |person| person.first_name.reverse.capitalize }
      age 40
      shoes(:count => 4) { |person, index| "shoe #{index}" }
    end
  end

  let(:generator) { Fabrication::Generator::Base.new(Person, schematic) }

  let(:person) do
    generator.generate({:first_name => 'Body'})
  end

  it 'passes the object to blocks' do
    person.last_name.should == 'Ydob'
  end

  it 'passes the object and count to blocks' do
    person.shoes.should == (1..4).map { |i| "shoe #{i}" }
  end

  it 'generates an instance' do
    person.instance_of?(Person).should be_true
  end

  it 'generates the first name immediately' do
    person.instance_variable_get(:@first_name).should == 'Body'
  end

  it 'generates the last name immediately' do
    person.instance_variable_get(:@last_name).should == 'Ydob'
  end

  it 'generates the age immediately' do
    person.instance_variable_get(:@age).should == 40
  end

end
