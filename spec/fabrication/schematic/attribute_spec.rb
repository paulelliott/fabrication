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
        expect(Proc).to be === subject.value
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

    context 'collection block with random amount' do
      let(:random_amount) { 3 }
      let(:attribute) do
        Fabrication::Schematic::Attribute.new(Object, "a", nil, {rand: random_amount}) { 'something' }
      end

      it 'returns random number of items in collection with a max of passed in value' do
        expect(1..random_amount).to be_member(attribute.processed_value({}).length)
      end
    end

    context 'collection block with random amount given as range' do
      let(:random_amount_range) { 10..21 }
      let(:attribute) do
        Fabrication::Schematic::Attribute.new(Object, "a", nil, {rand: random_amount_range}) { 'something' }
      end

      it 'returns random number of items in collection with a max of passed in value' do
        expect(random_amount_range).to be_member(attribute.processed_value({}).length)
      end
    end

    context 'collection block with random amount within a range' do
      let(:range_start) { 10 }
      let(:range_end) { 21 }
      let(:attribute) do
        Fabrication::Schematic::Attribute.new(Object, "a", nil, {start_range: range_start, end_range: range_end}) { 'something' }
      end

      it 'returns random number of items in collection with a min and max of passed in value' do
        expect(range_start..range_end).to be_member(attribute.processed_value({}).length)
      end
    end
  end
end
