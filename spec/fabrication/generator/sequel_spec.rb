require 'spec_helper'

describe Fabrication::Generator::Sequel do

  describe ".supports?" do
    subject { Fabrication::Generator::Sequel }
    it "returns true for sequel objects" do
      subject.supports?(Artist).should be_true
    end
    it "returns false for non-sequel objects" do
      subject.supports?(Person).should be_false
    end
  end

  describe "#after_generation" do
    let(:instance) { mock(:instance) }
    let(:generator) { Fabrication::Generator::Sequel.new(Object) }

    before { generator.send(:instance=, instance) }

    it "saves with a true save flag" do
      instance.should_receive(:save!)
      generator.send(:after_generation, {:save => true})
    end

    it "does not save without a true save flag" do
      instance.should_not_receive(:save)
      generator.send(:after_generation, {})
    end
  end

end
