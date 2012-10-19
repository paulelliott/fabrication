require 'spec_helper'

describe Fabrication::Schematic::Attribute do

  describe ".new" do
    context "with name, params, and a static value" do
      subject do
        Fabrication::Schematic::Attribute.new(Object, "a", "c", {:b => 1})
      end

      its(:klass)  { should == Object }
      its(:name)   { should == "a" }
      its(:params) { should == {:b => 1} }
      its(:value)  { should == "c" }
      it { should_not be_transient }
    end

    context "with a block value" do
      subject do
        Fabrication::Schematic::Attribute.new(Object, "a", Proc.new { "c" })
      end

      it "has a proc for a value" do
        Proc.should === subject.value
      end
    end

    context "with nils" do
      subject { Fabrication::Schematic::Attribute.new(Object, "a", nil) }
      its(:params) { should == {} }
      its(:value) { should be_nil }
    end
  end

  describe '#transient?' do
    subject { Fabrication::Schematic::Attribute.new(Object, "a", nil, transient: true) }
    it { should be_transient }
  end

  describe '#processed_value' do
    subject { attribute.processed_value({}) }

    context 'singular value' do
      let(:attribute) { Fabrication::Schematic::Attribute.new(Object, "a", "something") }
      it { should == 'something' }
    end

    context 'singular block' do
      let(:attribute) do
        Fabrication::Schematic::Attribute.new(Object, "a", nil, {}) { 'something' }
      end
      it { should == 'something' }
    end

    context 'collection block' do
      let(:attribute) do
        Fabrication::Schematic::Attribute.new(Object, "a", nil, {count: 2}) { 'something' }
      end
      it { should == %w(something something) }
    end
  end
end
