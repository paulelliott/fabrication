require 'spec_helper'

describe Fabrication::Transform do

  before do
    Fabrication.clear_definitions
    Fabrication::Transform.clear_all
  end

  describe '.apply_to' do
    context 'find definitions' do
      context 'transforms are empty' do
        it 'loads the definitions' do
          Fabrication::Support.should_receive(:find_definitions)
          Fabrication::Transform.apply_to(nil, :name => 'Shay')
        end
      end

      context 'transforms are not empty' do
        it 'does not load the definitions' do
          Fabrication::Transform.apply_to(nil, :name => 'Shay')
          Fabrication::Support.should_not_receive(:find_definitions)
          Fabrication::Transform.apply_to(nil, :name => 'Gabriel')
        end
      end
    end

    context 'when there is a generic transform for that column' do
      before do
        Fabrication::Transform.define(:city, lambda {|value| value.split.first})
      end

      context 'fabricating an instance that is described by the per fabricator transform' do
        before do
          Fabrication::Transform.only_for(:address, :city, lambda {|value| value.upcase})
        end

        it 'applies the transform to the specified types' do
          Fabrication::Transform.apply_to(:address, {:city => 'Jacksonville Beach'}).should == {:city => 'JACKSONVILLE BEACH'}
        end
      end

      context 'no override has been defined' do
        it 'applies the generic transform' do
          Fabrication::Transform.apply_to(:address, {:city => 'Jacksonville Beach'}).should == {:city => 'Jacksonville'}
        end
      end
    end

    context 'when no generic transform has been defined' do
      it 'does not change value' do
        Fabrication::Transform.apply_to(:address, {:city => 'Jacksonville Beach'}).should == {:city => 'Jacksonville Beach'}
      end
    end

    context 'ensuring precedence' do
      context 'override is done before generic transform' do
        before do
          Fabrication::Transform.only_for(:address, :city, lambda {|value| value.upcase})
          Fabrication::Transform.define(:city, lambda {|value| value.split.first})
        end

        it 'applies corretly' do
          Fabrication::Transform.apply_to(:address, {:city => 'Jacksonville Beach'}).should == {:city => 'JACKSONVILLE BEACH'}
        end
      end
    end
  end

  describe '.clear_all' do
    it 'clears all transforms' do
      Fabrication::Transform.define(:name, lambda {|value| value})
      Fabrication::Transform.only_for(:address, :name, lambda {|value| value})
      Fabrication::Transform.clear_all
      Fabrication::Transform.send(:transforms).should be_empty
      Fabrication::Transform.send(:overrides).should be_empty
    end
  end

  describe '.define' do
    it 'registers transform' do
      lambda {
        Fabrication::Transform.define(:name, lambda {|value| value})
      }.should change(Fabrication::Transform, :transforms)
    end
  end

  describe '.only_for' do
    it 'registers an override transform for provided model' do
      lambda {
        Fabrication::Transform.only_for(:address, :name, lambda {|value| value})
      }.should change(Fabrication::Transform, :overrides)
    end
  end

end
