require 'spec_helper'

describe Fabrication::Generator::Base do

  describe ".supports?" do
    subject { Fabrication::Generator::Base }
    it "supports any object" do
      subject.supports?(Object).should be_true
    end
  end

  describe "#build" do

    let(:generator) { Fabrication::Generator::Base.new(Person) }

    let(:attributes) do
      Fabrication::Schematic::Definition.new(Person) do
        first_name 'Guy'
        shoes(:count => 4) do |attrs, index|
          "#{attrs[:first_name]}'s shoe #{index}"
        end
      end.attributes
    end

    let(:person) { generator.build(attributes) }

    it 'generates an instance' do
      person.instance_of?(Person).should be_true
    end

    it 'passes the object and count to blocks' do
      person.shoes.should == (1..4).map { |i| "Guy's shoe #{i}" }
    end

    it 'sets the static value' do
      person.instance_variable_get(:@first_name).should == 'Guy'
    end

    context "with on_init block" do
      subject { schematic.fabricate }

      let(:klass) { Struct.new :arg1, :arg2 }

      context "using init_with" do
        let(:schematic) do
          Fabrication::Schematic::Definition.new(klass) do
            on_init { init_with(:a, :b) }
          end
        end

        it "sends the return value of the block to the klass' initialize method" do
          subject.arg1.should == :a
          subject.arg2.should == :b
        end
      end

      context "not using init_with" do
        let(:schematic) do
          Fabrication::Schematic::Definition.new(klass) do
            on_init { [ :a, :b ] }
          end
        end

        it "sends the return value of the block to the klass' initialize method" do
          subject.arg1.should == :a
          subject.arg2.should == :b
        end

      end
    end

    context "with initialize_with block" do
      subject { schematic.fabricate }

      let(:klass) { Struct.new :arg1, :arg2 }

      context "using only raw values" do
        let(:schematic) do
          Fabrication::Schematic::Definition.new(klass) do
            initialize_with { Struct.new(:arg1, :arg2).new(:fixed_value) }
          end
        end

        it "saves the return value of the block as instance" do
          subject.arg1.should == :fixed_value
          subject.arg2.should == nil
        end
      end

      context "using attributes inside block" do
        let(:schematic) do
           Fabrication::Schematic::Definition.new(klass) do
             arg1 10
             initialize_with { Struct.new(:arg1, :arg2).new(arg1, arg1 + 10) }
          end
        end

        context "without override" do
          it "saves the return value of the block as instance" do
            subject.arg1.should == 10
            subject.arg2.should == 20
          end
        end

        context "with override" do
          subject { schematic.fabricate(arg1: 30) }
          it "saves the return value of the block as instance" do
            subject.arg1.should == 30
            subject.arg2.should == 40
          end
        end

      end
    end

    context "using an after_create hook" do
      let(:schematic) do
        Fabrication::Schematic::Definition.new(Person) do
          first_name "Guy"
          after_create { |k| k.first_name.upcase! }
        end
      end

      it "calls after_create when generated with saving" do
        schematic.fabricate.first_name.should == "GUY"
      end

      it "does not call after_create when generated without saving" do
        schematic.build.first_name.should == "Guy"
      end
    end

    context 'all the callbacks' do
      subject { schematic.build }
      let(:schematic) do
        Fabrication::Schematic::Definition.new(Person) do
          first_name ""
          after_build { |k| k.first_name += '1' }
          before_validation { |k| k.first_name += '2' }
          after_validation { |k| k.first_name += '3' }
        end
      end
      its(:first_name) { should == '1' }
    end
  end

  describe '#create' do
    context 'all the callbacks' do
      subject { schematic.fabricate }
      let(:schematic) do
        Fabrication::Schematic::Definition.new(Person) do
          first_name ""
          after_build { |k| k.first_name += '1' }
          before_validation { |k| k.first_name += '2' }
          after_validation { |k| k.first_name += '3' }
          before_save { |k| k.first_name += '4' }
          before_create { |k| k.first_name += '5' }
          after_create { |k| k.first_name += '6' }
          after_save { |k| k.first_name += '7' }
        end
      end
      its(:first_name) { should == '1234567' }
    end
  end

  describe "#persist" do
    let(:instance) { double }
    let(:generator) { Fabrication::Generator::Base.new(Object) }

    before { generator.send(:_instance=, instance) }

    it 'saves' do
      instance.should_receive(:save!)
      generator.send(:persist)
    end
  end

  describe 'robustness tests' do
    it 'maintains valid state on exceptions while building' do
      expect { Fabricate.build(:troublemaker, raise_exception: true) }.to raise_exception "Troublemaker exception"
      Fabricate(:persistable).persisted?.should be_true
    end
  end

end
