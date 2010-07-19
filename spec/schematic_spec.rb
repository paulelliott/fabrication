require 'spec_helper'

describe Fabrication::Schematic do

  let(:schematic) do
    Fabrication::Schematic.new do
      name "Orgasmo"
      something(:param => 2) { "hi!" }
      another_thing { 25 }
    end
  end

  context "without inheritance" do

    subject { schematic }

    it "stored 'name' correctly" do
      attribute = subject.attribute(:name)
      attribute.name.should == :name
      attribute.params.should be_nil
      attribute.value.should == "Orgasmo"
    end

    it "stored 'something' correctly" do
      attribute = subject.attribute(:something)
      attribute.name.should == :something
      attribute.params.should == { :param => 2 }
      Proc.should === attribute.value
      attribute.value.call.should == "hi!"
    end

    it "stored 'another_thing' correctly" do
      attribute = subject.attribute(:another_thing)
      attribute.name.should == :another_thing
      attribute.params.should be_nil
      Proc.should === attribute.value
      attribute.value.call.should == 25
    end

  end

  context "with inheritance" do

    subject do
      schematic.merge! do
        name { "Willis" }
        something "Else!"
        another_thing(:thats_what => 'she_said') { "Boo-ya!" }
      end
    end

    it "stored 'name' correctly" do
      attribute = subject.attribute(:name)
      attribute.name.should == :name
      attribute.params.should be_nil
      Proc.should === attribute.value
      attribute.value.call.should == "Willis"
    end

    it "stored 'something' correctly" do
      attribute = subject.attribute(:something)
      attribute.name.should == :something
      attribute.params.should be_nil
      attribute.value.should == "Else!"
    end

    it "stored 'another_thing' correctly" do
      attribute = subject.attribute(:another_thing)
      attribute.name.should == :another_thing
      attribute.params.should == { :thats_what => 'she_said' }
      Proc.should === attribute.value
      attribute.value.call.should == "Boo-ya!"
    end

  end

  it 'is deep clonable' do
    schematic2 = schematic.clone
    schematic.merge! do
      name "Henry"
    end
    schematic.attribute(:name).value.should == 'Henry'
    schematic2.attribute(:name).value.should == 'Orgasmo'
  end

  it 'allows temporary parameter overrides' do
    schematic2 = schematic.merge(:name => 'Henry')
    schematic.attribute(:name).value.should == 'Orgasmo'
    schematic2.attribute(:name).value.should == 'Henry'
  end

end
