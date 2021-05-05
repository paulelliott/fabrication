require 'spec_helper'

describe Fabrication::Schematic::Attribute do
  describe '.new' do
    context 'with name, params, and a static value' do
      subject do
        described_class.new(Object, 'a', 'c', { b: 1 })
      end

      its(:klass)  { should == Object }
      its(:name)   { should == 'a' }
      its(:params) { should == { b: 1 } }
      its(:value)  { should == 'c' }
      it { should_not be_transient }
    end

    context 'with a block value' do
      let(:attribute) do
        described_class.new(Object, 'a', proc { 'c' })
      end

      it 'has a proc for a value' do
        expect(attribute.value).to be_a(Proc)
      end
    end

    context 'with nils' do
      subject { described_class.new(Object, 'a', nil) }

      its(:params) { should == {} }
      its(:value) { should be_nil }
    end
  end

  describe '#transient?' do
    subject { described_class.new(Object, 'a', nil, transient: true) }

    it { should be_transient }
  end

  describe '#processed_value' do
    subject { attribute.processed_value({}) }

    context 'with a singular value' do
      let(:attribute) { described_class.new(Object, 'a', 'something') }

      it { should == 'something' }
    end

    context 'with a singular block' do
      let(:attribute) do
        described_class.new(Object, 'a', nil, {}) { 'something' }
      end

      it { should == 'something' }
    end

    context 'with a collection block' do
      let(:attribute) do
        described_class.new(Object, 'a', nil, { count: 2 }) { 'something' }
      end

      it { should == %w[something something] }
    end

    context 'with a collection block with random amount' do
      let(:random_amount) { 3 }
      let(:attribute) do
        described_class.new(Object, 'a', nil, { rand: random_amount }) { 'something' }
      end

      it 'returns random number of items in collection with a max of passed in value' do
        expect(1..random_amount).to be_member(attribute.processed_value({}).length)
      end
    end

    context 'with a collection block with random amount given as range' do
      let(:random_amount_range) { 10..21 }
      let(:attribute) do
        described_class.new(Object, 'a', nil, { rand: random_amount_range }) { 'something' }
      end

      it 'returns random number of items in collection with a max of passed in value' do
        expect(random_amount_range).to be_member(attribute.processed_value({}).length)
      end
    end

    context 'with a collection block with random amount within a range' do
      let(:range_start) { 10 }
      let(:range_end) { 21 }
      let(:attribute) do
        described_class.new(Object, 'a', nil, { start_range: range_start, end_range: range_end }) do
          'something'
        end
      end

      it 'returns random number of items in collection with a min and max of passed in value' do
        expect(range_start..range_end).to be_member(attribute.processed_value({}).length)
      end
    end
  end
end
