require 'spec_helper'

describe Fabrication::Fabricator do

  subject { Fabrication::Fabricator }

  describe ".define" do

    let(:options) { { aliases: ["thing_one", :thing_two] } }

    before(:all) do
      subject.define(:open_struct, options) do
        first_name "Joe"
        last_name { "Schmoe" }
      end
    end

    it "returns the schematic" do
      subject.define(:something, :class_name => :open_struct) do
        name "Paul"
      end.class.should == Fabrication::Schematic
    end

    it "creates a schematic" do
      subject.schematics[:open_struct].should be
    end

    it "has the correct class" do
      subject.schematics[:open_struct].klass.should == OpenStruct
    end

    it "has the attributes" do
      subject.schematics[:open_struct].attributes.size.should == 2
    end

    context "with an alias" do

      it "recognizes the aliases" do
        subject.schematics[:thing_one].should == subject.schematics[:open_struct]
        subject.schematics[:thing_two].should == subject.schematics[:open_struct]
      end
    end
  end

  describe ".generate" do

    context 'without definitions' do

      before { subject.schematics.clear }

      it "finds definitions if none exist" do
        Fabrication::Support.should_receive(:find_definitions)
        lambda { subject.generate(:object) }.should raise_error
      end

    end

    context 'with definitions' do

      it "raises an error if the class cannot be located" do
        lambda { subject.define(:somenonexistantclass) }.should raise_error(Fabrication::UnfabricatableError)
      end

      it "raises an error if the fabricator cannot be located" do
        lambda { subject.generate(:object) }.should raise_error(Fabrication::UnknownFabricatorError)
      end

      it 'generates a new object every time' do
        subject.generate(:person).should_not == subject.generate(:person)
      end

    end

  end

end
