require 'spec_helper'

describe Fabrication::Fabricator do

  subject { Fabrication::Fabricator }

  describe ".generate" do

    context 'without definitions' do

      before { Fabrication.schematics.clear }

      it "finds definitions if none exist" do
        Fabrication::Support.should_receive(:find_definitions)
        lambda { subject.generate(:object) }.should raise_error
      end

    end

    context 'with definitions' do

      it "raises an error if the fabricator cannot be located" do
        lambda { subject.generate(:object) }.should raise_error(Fabrication::UnknownFabricatorError)
      end

      it 'generates a new object every time' do
        subject.generate(:person).should_not == subject.generate(:person)
      end

    end

  end

end
