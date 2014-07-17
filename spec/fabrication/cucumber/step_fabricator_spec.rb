require 'spec_helper'

describe Fabrication::Cucumber::StepFabricator do
  let(:name) { 'dogs' }

  describe '#klass' do
    context 'with a schematic for class "Boom"' do
      subject { Fabrication::Cucumber::StepFabricator.new(name).klass }
      let(:fabricator_name) { :dog }

      before do
        allow(Fabricate).to receive(:schematic).with(fabricator_name).and_return(double(klass: "Boom"))
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
      expect(Fabricate).to receive(:create).with(:dog, {}).exactly(n).times
      fabricator.n n
    end

    it "fabricates with attrs" do
      expect(Fabricate).to receive(:create).
        with(:dog, :collar => 'red').at_least(1)
      fabricator.n n, :collar => 'red'
    end

    context 'with a plural subject' do
      let(:name) { 'dogs' }
      it 'remembers' do
        allow(Fabricate).to receive(:create).and_return("dog1", "dog2", "dog3")
        fabricator.n n
        expect(Fabrication::Cucumber::Fabrications[name]).to eq(["dog1", "dog2", "dog3"])
      end
    end

    context 'with a singular subject' do
      let(:name) { 'dog' }
      it 'remembers' do
        allow(Fabricate).to receive(:create).and_return("dog1")
        fabricator.n 1
        expect(Fabrication::Cucumber::Fabrications[name]).to eq('dog1')
      end
    end

  end

  describe '#from_table' do
    it 'maps column names to attribute names' do
      table = double(hashes: [{ 'Favorite Color' => 'pink' }])
      expect(Fabricate).to receive(:create).with(:bear, :favorite_color => 'pink')
      Fabrication::Cucumber::StepFabricator.new('bears').from_table(table)
    end

    context 'with table transforms' do
      let(:table) { double(hashes: [{ 'some' => 'thing' }]) }
      before { allow(Fabricate).to receive(:create) }

      it 'applies transforms' do
        expect(Fabrication::Transform).to receive(:apply_to).
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
        expect(Fabricate).to receive(:create).with(:dog, {:some => 'thing'})
        expect(Fabricate).to receive(:create).with(:dog, {:some => 'panother'})
        Fabrication::Cucumber::StepFabricator.new(name).from_table(table)
      end
      it 'remembers' do
        allow(Fabricate).to receive(:create).and_return('dog1', 'dog2')
        Fabrication::Cucumber::StepFabricator.new(name).from_table(table)
        expect(Fabrication::Cucumber::Fabrications[name]).to eq(["dog1", "dog2"])
      end
    end

    context 'singular' do
      let(:name) { 'dog' }
      let(:table) { double("ASTable", :rows_hash => rows_hash) }
      let(:rows_hash) do
        {'some' => 'thing'}
      end
      it 'fabricates with each row as an attribute' do
        expect(Fabricate).to receive(:create).with(:dog, {:some => 'thing'})
        Fabrication::Cucumber::StepFabricator.new(name).from_table(table)
      end
      it 'remembers' do
        allow(Fabricate).to receive(:create).and_return('dog1')
        Fabrication::Cucumber::StepFabricator.new(name).from_table(table)
        expect(Fabrication::Cucumber::Fabrications[name]).to eq("dog1")
      end
    end
  end

end
