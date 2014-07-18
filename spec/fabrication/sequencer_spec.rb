require 'spec_helper'

describe Fabrication::Sequencer do

  context 'with no arguments' do
    subject { Fabrication::Sequencer.sequence }

    it { should == 0 }
    it 'creates a default sequencer' do
      expect(Fabrication::Sequencer.sequences[:_default]).to eq(1)
    end
  end

  context 'with only a name' do

    it 'starts with 0' do
      expect(Fabricate.sequence(:incr)).to eq(0)
    end

    it 'increments by one with each call' do
      expect(Fabricate.sequence(:incr)).to eq(1)
      expect(Fabricate.sequence(:incr)).to eq(2)
      expect(Fabricate.sequence(:incr)).to eq(3)
      expect(Fabricate.sequence(:incr)).to eq(4)
    end

    it 'increments counters separately' do
      expect(Fabricate.sequence(:number)).to eq(0)
      expect(Fabricate.sequence(:number)).to eq(1)
      expect(Fabricate.sequence(:number)).to eq(2)
      expect(Fabricate.sequence(:number)).to eq(3)
    end

  end

  context 'with a name and starting number' do

    it 'starts with the number provided' do
      expect(Fabricate.sequence(:higher, 69)).to eq(69)
    end

    it 'increments by one with each call' do
      expect(Fabricate.sequence(:higher)).to eq(70)
      expect(Fabricate.sequence(:higher, 69)).to eq(71)
      expect(Fabricate.sequence(:higher)).to eq(72)
      expect(Fabricate.sequence(:higher)).to eq(73)
    end

  end

  context 'with a block' do

    it 'yields the number to the block and returns the value' do
      expect(Fabricate.sequence(:email) do |i|
        "user#{i}@example.com"
      end).to eq("user0@example.com")
    end

    it 'increments by one with each call' do
      expect(Fabricate.sequence(:email) do |i|
        "user#{i}@example.com"
      end).to eq("user1@example.com")

      expect(Fabricate.sequence(:email) do |i|
        "user#{i}@example.com"
      end).to eq("user2@example.com")
    end

    context 'and then without a block' do
      it 'remembers the original block' do
        Fabricate.sequence :changing_blocks do |i|
          i * 10
        end
        expect(Fabricate.sequence(:changing_blocks)).to eq(10)
      end
      context 'and then with a new block' do
        it 'evaluates the new block' do
          expect(Fabricate.sequence(:changing_blocks) { |i| i ** 2 }).to eq(4)
        end
        it 'remembers the new block' do
          expect(Fabricate.sequence(:changing_blocks)).to eq(9)
        end
      end
    end
  end
  context 'with two sequences declared with blocks' do
    it 'remembers both blocks' do
      Fabricate.sequence(:shapes) do |i|
        %w[square circle rectangle][i % 3]
      end
      Fabricate.sequence(:colors) do |i|
        %w[red green blue][i % 3]
      end
      expect(Fabricate.sequence(:shapes)).to eq('circle')
      expect(Fabricate.sequence(:colors)).to eq('green')
    end
  end

  context "with a default sequence start" do
    before do
      Fabrication::Sequencer.reset
      Fabrication::Config.sequence_start = 10000
    end

    it "starts a new sequence at the default" do
      expect(Fabricate.sequence(:default_test)).to eq(10000)
    end

    it "respects start value passed as an argument" do
      expect(Fabricate.sequence(:default_test2, 9)).to eq(9)
    end

    after do
      Fabrication::Sequencer.reset
    end
  end
end
