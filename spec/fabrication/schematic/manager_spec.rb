require 'spec_helper'

describe Fabrication::Schematic::Manager do

  let(:manager) { Fabrication::Schematic::Manager.instance }
  before { manager.clear }

  describe "#register" do
    subject { manager }

    let(:options) { { aliases: ["thing_one", :thing_two] } }

    before do
      manager.register(:open_struct, options) do
        first_name "Joe"
        last_name { "Schmoe" }
      end
    end

    it "creates a schematic" do
      subject.schematics[:open_struct].should be
    end

    it "has the correct class" do
      subject.schematics[:open_struct].klass.should == OpenStruct
    end

    it "has the attributes" do
      subject.schematics[:open_struct].attributes.size.should == 2
    end

    context "with an alias" do
      it "recognizes the aliases" do
        subject.schematics[:thing_one].should == subject.schematics[:open_struct]
        subject.schematics[:thing_two].should == subject.schematics[:open_struct]
      end
    end

  end

  describe '#[]' do
    subject { manager[key] }
    before { manager.schematics[:some] = 'thing' }

    context 'with a symbol' do
      let(:key) { :some }
      it { should == 'thing' }
    end

    context 'with a string' do
      let(:key) { 'some' }
      it { should == 'thing' }
    end
  end

  describe ".load_definitions" do
    before { Fabrication.clear_definitions }

    context 'with multiple path_prefixes and fabricator_paths' do
      it 'loads them all' do
        expect(Fabrication::Config.path_prefixes).to receive(:each).and_call_original
        expect(Fabrication::Config.fabricator_paths).to receive(:each)
        Fabrication.manager.load_definitions
      end
    end

    context 'happy path' do
      it "loaded definitions" do
        Fabrication.manager.load_definitions
        Fabrication.manager[:parent_ruby_object].should be
      end
    end

    context 'when an error occurs during the load' do
      it 'still freezes the manager' do
        expect(Fabrication::Config).to receive(:fabricator_paths).and_raise(Exception)
        expect { Fabrication.manager.load_definitions }.to raise_error
        Fabrication.manager.should_not be_initializing
      end
    end
  end

end
