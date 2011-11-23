require 'spec_helper'

describe Fabrication::Transform do

  before do
    Fabrication::Transform.clear_all
  end

  describe '.apply' do
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
