require 'spec_helper'

describe "Fabricate.sequence" do

  context 'with only a name' do

    it 'starts with 0' do
      Fabricate.sequence(:incr).should == 0
    end

    it 'increments by one with each call' do
      Fabricate.sequence(:incr).should == 1
      Fabricate.sequence(:incr).should == 2
      Fabricate.sequence(:incr).should == 3
      Fabricate.sequence(:incr).should == 4
    end

    it 'increments counters separately' do
      Fabricate.sequence(:number).should == 0
      Fabricate.sequence(:number).should == 1
      Fabricate.sequence(:number).should == 2
      Fabricate.sequence(:number).should == 3
    end

  end

  context 'with a name and starting number' do

    it 'starts with the number provided' do
      Fabricate.sequence(:higher, 69).should == 69
    end

    it 'increments by one with each call' do
      Fabricate.sequence(:higher).should == 70
      Fabricate.sequence(:higher, 69).should == 71
      Fabricate.sequence(:higher).should == 72
      Fabricate.sequence(:higher).should == 73
    end

  end

  context 'with a block' do

    it 'yields the number to the block and returns the value' do
      Fabricate.sequence(:email) do |i|
        "user#{i}@example.com"
      end.should == "user0@example.com"
    end

    it 'increments by one with each call' do
      Fabricate.sequence(:email) do |i|
        "user#{i}@example.com"
      end.should == "user1@example.com"

      Fabricate.sequence(:email) do |i|
        "user#{i}@example.com"
      end.should == "user2@example.com"
    end

  end

end
