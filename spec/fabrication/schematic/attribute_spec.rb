require 'spec_helper'

describe Fabrication::Schematic::Attribute do

  describe ".new" do
    context "with name, params, and a static value" do
      subject do
        Fabrication::Schematic::Attribute.new("a", {:b => 1}, "c")
      end

      its(:name)   { should == "a" }
      its(:params) { should == {:b => 1} }
      its(:value)  { should == "c" }
      it { should_not be_transient }
    end

    context "with a block value" do
      subject do
        Fabrication::Schematic::Attribute.new("a", nil, Proc.new { "c" })
      end

      it "has a proc for a value" do
        Proc.should === subject.value
      end
    end

    context "with nils" do
      subject { Fabrication::Schematic::Attribute.new("a", nil, nil) }
      its(:params) { should == {} }
      its(:value) { should be_nil }
    end
  end

  describe '#transient?' do
    subject { Fabrication::Schematic::Attribute.new("a", transient: true) }
    it { should be_transient }
  end
end
