require 'spec_helper'

describe Fabrication::Schematic do

  let(:schematic) do
    Fabrication::Schematic.new(OpenStruct) do
      name "Orgasmo"
      something(:param => 2) { "hi!" }
      another_thing { 25 }
    end
  end

  describe ".new" do
    it "stores the klass" do
      schematic.klass.should == OpenStruct
    end
    it "stores the generator" do
      schematic.generator.should == Fabrication::Generator::Base
    end
    it "stores the attributes" do
      schematic.attributes.size.should == 3
    end
  end

  describe "#attribute" do
    it "returns the requested attribute if it exists" do
      schematic.attribute(:name).name.should == :name
    end
    it "returns nil if it does not exist" do
      schematic.attribute(:not_there).should be_nil
    end
  end

  describe "#attributes" do
    it "always returns an empty array" do
      schematic.attributes = nil
      schematic.attributes.should == []
    end
  end

  describe "#generate" do

    context "an instance" do

      it "generates a new instance" do
        schematic.generate.should be_kind_of(OpenStruct)
      end

    end

    context "an attributes hash" do

      let(:hash) { schematic.generate(:attributes => true) }

      it "generates a hash with the object's attributes" do
        hash.should be_kind_of(Hash)
      end

      it "has the correct attributes" do
        hash.size.should == 3
        hash[:name].should == 'Orgasmo'
        hash[:something].should == "hi!"
        hash[:another_thing].should == 25
      end

    end

  end

  describe "#merge" do

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
        schematic.merge do
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

  end

end
