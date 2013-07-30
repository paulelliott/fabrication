require 'spec_helper'

describe Fabrication::Schematic::Definition do

  let(:schematic) do
    Fabrication::Schematic::Definition.new(OpenStruct) do
      name "Orgasmo"
      something(:param => 2) { "hi!" }
      another_thing { 25 }
    end
  end

  describe "generator selection" do
    subject { Fabrication::Schematic::Definition.new(klass).generator }

    context "for an activerecord object" do
      let(:klass) { ParentActiveRecordModel }
      it { should == Fabrication::Generator::ActiveRecord }
    end

    context "for a mongoid object" do
      let(:klass) { ParentMongoidDocument }
      it { should == Fabrication::Generator::Mongoid }
    end

    context "for a sequel object" do
      let(:klass) { ParentSequelModel }
      it { should == Fabrication::Generator::Sequel }
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

  describe "#fabricate" do
    context "an instance" do
      it "generates a new instance" do
        schematic.fabricate.should be_kind_of(OpenStruct)
      end
    end
  end

  describe "#to_attributes" do
    let(:hash) { schematic.to_attributes }

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

  describe "#merge" do

    context "without inheritance" do

      subject { schematic.merge }

      it { should_not == schematic }

      it "stored 'name' correctly" do
        attribute = subject.attribute(:name)
        attribute.name.should == :name
        attribute.params.should == {}
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
        attribute.params.should == {}
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

      it { should_not == schematic }

      it "stored 'name' correctly" do
        attribute = subject.attribute(:name)
        attribute.name.should == :name
        attribute.params.should == {}
        Proc.should === attribute.value
        attribute.value.call.should == "Willis"
      end

      it "stored 'something' correctly" do
        attribute = subject.attribute(:something)
        attribute.name.should == :something
        attribute.params.should == {}
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

  describe "#on_init" do
    let(:init_block) { lambda {} }
    let(:init_schematic) do
      block = init_block
      Fabrication::Schematic::Definition.new(OpenStruct) do
        on_init &block
      end
    end

    it "stores the on_init callback" do
      init_schematic.callbacks[:on_init].should == init_block
    end

    context "with inheritance" do
      let(:child_block) { lambda {} }
      let(:child_schematic) do
        block = child_block
        init_schematic.merge do
          on_init &block
        end
      end

      it "overwrites the on_init callback" do
        child_schematic.callbacks[:on_init].should == child_block
      end
    end
  end

  describe "#initialize_with" do
    let(:init_block) { lambda {} }
    let(:init_schematic) do
      block = init_block
      Fabrication::Schematic::Definition.new(OpenStruct) do
        initialize_with &block
      end
    end

    it "stores the initialize_with callback" do
      init_schematic.callbacks[:initialize_with].should == init_block
    end

    context "with inheritance" do
      let(:child_block) { lambda {} }
      let(:child_schematic) do
        block = child_block
        init_schematic.merge do
          initialize_with &block
        end
      end

      it "overwrites the initialize_with callback" do
        child_schematic.callbacks[:initialize_with].should == child_block
      end
    end
  end

  describe '#transient' do
    let(:definition) do
      Fabrication::Schematic::Definition.new(OpenStruct) do
        transient :one, :two => 'with a default value', :three => 200
      end
    end

    it 'stores the attributes as transient' do
      definition.attributes.map(&:transient?).should == [true, true, true]
    end

    it "accept default value" do
      definition.attributes[1].name.should == :two
      definition.attributes[1].value.should == 'with a default value'
      definition.attributes[2].name.should == :three
      definition.attributes[2].value.should == 200
    end
  end

  context "when overriding" do
    let(:address) { Address.new }

    it "symbolizes attribute keys" do
      Fabricator(:address) { city { raise 'should not be called' } }
      Fabricator(:contact) { address }
      expect { Fabricate(:contact, 'address' => address) }.not_to raise_error
    end
  end
end
