require 'spec_helper'

describe Fabrication::Transform do

  before do
    Fabrication.clear_definitions
    Fabrication::Transform.clear_all
  end

  describe '.apply' do
    context 'find definitions' do
      context 'transforms are empty' do
        it 'loads the definitions' do
          Fabrication::Support.should_receive(:find_definitions)
          Fabrication::Transform.apply(:name => 'Shay')
        end
      end

      context 'transforms are not empty' do
        it 'does not load the definitions' do
          Fabrication::Transform.apply(:name => 'Shay')
          Fabrication::Support.should_not_receive(:find_definitions)
          Fabrication::Transform.apply(:name => 'Gabriel')
        end
      end
    end

    context 'attributes include a key with transform defined' do
      before do
        Fabrication::Transform.define(:name, lambda {|value| value.reverse})
      end

      it 'transform is applied' do
        Fabrication::Transform.apply({:name => 'Shay'}).should == {:name => 'yahS'}
      end
    end

    context 'attributes do not include a key with transform defined' do
      before do
        Fabrication::Transform.define(:name, lambda {|value| value.reverse})
      end

      it 'no transform is applied' do
        Fabrication::Transform.apply({:favorite_color => 'blue'}).should == {:favorite_color => 'blue'}
      end
    end

    context 'no transforms are defined' do
      it 'no transform is applied' do
        Fabrication::Transform.apply({:favorite_color => 'blue'}).should == {:favorite_color => 'blue'}
      end
    end

  end

  describe '.clear_all' do
    it 'clears all transforms' do
      Fabrication::Transform.define(:name, lambda {|value| value})
      Fabrication::Transform.clear_all
      Fabrication::Transform.send(:transforms).should be_empty
    end
  end

  describe '.define' do
    it 'registers transform' do
      lambda {
        Fabrication::Transform.define(:name, lambda {|value| value})
      }.should change(Fabrication::Transform, :transforms)
    end
  end

end
