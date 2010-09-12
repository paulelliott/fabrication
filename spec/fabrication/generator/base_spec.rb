require 'spec_helper'

describe Fabrication::Generator::Base do

  describe ".supports?" do
    subject { Fabrication::Generator::Base }
    it "supports any object" do
      subject.supports?(Object).should be_true
    end
  end

  describe "#generate" do

    let(:generator) { Fabrication::Generator::Base.new(Person) }

    let(:attributes) do
      Fabrication::Schematic.new(Person) do
        first_name 'Guy'
        shoes(:count => 4) do |person, index|
          "#{person.first_name}'s shoe #{index}"
        end
      end.attributes
    end

    let(:person) { generator.generate({}, attributes) }

    it 'generates an instance' do
      person.instance_of?(Person).should be_true
    end

    it 'passes the object and count to blocks' do
      person.shoes.should == (1..4).map { |i| "Guy's shoe #{i}" }
    end

    it 'sets the static value' do
      person.instance_variable_get(:@first_name).should == 'Guy'
    end

  end

end
