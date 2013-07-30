require 'spec_helper'

describe Fabrication::Cucumber do
  include described_class

  let(:name) { 'dogs' }

  describe '#klass' do
    context 'with a schematic for class "Boom"' do
      subject { Fabrication::Cucumber::StepFabricator.new(name).klass }
      let(:fabricator_name) { :dog }

      before do
        Fabrication.manager.stub(:[]).
          with(fabricator_name).and_return(double(klass: "Boom"))
      end

      it { should == "Boom" }

      context "given a human name" do
        let(:name) { "weiner dogs" }
        let(:fabricator_name) { :weiner_dog }
        it { should == "Boom" }
      end

      context "given a titlecase human name" do
        let(:name) { "Weiner Dog" }
        let(:fabricator_name) { :weiner_dog }
        it { should == "Boom" }
      end
    end
  end

  describe "#n" do
    let(:n) { 3 }
    let(:fabricator) { Fabrication::Cucumber::StepFabricator.new(name) }

    it "fabricates n times" do
      Fabrication::Fabricator.should_receive(:fabricate).with(:dog, {}).exactly(n).times
      fabricator.n n
    end

    it "fabricates with attrs" do
      Fabrication::Fabricator.should_receive(:fabricate).
        with(:dog, :collar => 'red').at_least(1)
      fabricator.n n, :collar => 'red'
    end

    context 'with a plural subject' do
      let(:name) { 'dogs' }
      it 'remembers' do
        Fabrication::Fabricator.stub(:fabricate).and_return("dog1", "dog2", "dog3")
        fabricator.n n
        Fabrication::Cucumber::Fabrications[name].should == ["dog1", "dog2", "dog3"]
      end
    end

    context 'with a singular subject' do
      let(:name) { 'dog' }
      it 'remembers' do
        Fabrication::Fabricator.stub(:fabricate).and_return("dog1")
        fabricator.n 1
        Fabrication::Cucumber::Fabrications[name].should == 'dog1'
      end
    end

  end

  describe '#from_table' do
    it 'maps column names to attribute names' do
      table = double(hashes: [{ 'Favorite Color' => 'pink' }])
      Fabrication::Fabricator.should_receive(:fabricate).
        with(:bear, :favorite_color => 'pink')
      Fabrication::Cucumber::StepFabricator.new('bears').from_table(table)
    end

    context 'with table transforms' do
      let(:table) { double(hashes: [{ 'some' => 'thing' }]) }

      before do
        Fabrication::Fabricator.stub(:fabricate)
      end

      it 'applies transforms' do
        Fabrication::Transform.should_receive(:apply_to).
          with('bears', {:some => 'thing'}).and_return({})
        Fabrication::Cucumber::StepFabricator.new('bears').from_table(table)
      end
    end

    context 'with a plural subject' do
      let(:table) { double("ASTable", :hashes => hashes) }
      let(:hashes) do
        [{'some' => 'thing'},
         {'some' => 'panother'}]
      end
      it 'fabricates with each rows attributes' do
        Fabrication::Fabricator.should_receive(:fabricate).
          with(:dog, {:some => 'thing'})
        Fabrication::Fabricator.should_receive(:fabricate).
          with(:dog, {:some => 'panother'})
        Fabrication::Cucumber::StepFabricator.new(name).from_table(table)
      end
      it 'remembers' do
        Fabrication::Fabricator.stub(:fabricate).and_return('dog1', 'dog2')
        Fabrication::Cucumber::StepFabricator.new(name).from_table(table)
        Fabrication::Cucumber::Fabrications[name].should == ["dog1", "dog2"]
      end
    end

    context 'singular' do
      let(:name) { 'dog' }
      let(:table) { double("ASTable", :rows_hash => rows_hash) }
      let(:rows_hash) do
        {'some' => 'thing'}
      end
      it 'fabricates with each row as an attribute' do
        Fabrication::Fabricator.should_receive(:fabricate).with(:dog, {:some => 'thing'})
        Fabrication::Cucumber::StepFabricator.new(name).from_table(table)
      end
      it 'remembers' do
        Fabrication::Fabricator.stub(:fabricate).and_return('dog1')
        Fabrication::Cucumber::StepFabricator.new(name).from_table(table)
        Fabrication::Cucumber::Fabrications[name].should == "dog1"
      end
    end
  end

end
