require 'spec_helper'

describe Fabrication::Generator::Base do

  describe ".supports?" do
    subject { Fabrication::Generator::Base }
    it "supports any object" do
      expect(subject.supports?(Object)).to be true
    end
  end

  describe "#build" do

    let(:generator) { Fabrication::Generator::Base.new(ParentRubyObject) }

    let(:attributes) do
      Fabrication::Schematic::Definition.new('ParentRubyObject') do
        string_field 'different content'
        extra_fields(count: 4) { |attrs, index| "field #{index}" }
      end.attributes
    end

    let(:parent_ruby_object) { generator.build(attributes) }

    it 'generates an instance' do
      expect(parent_ruby_object).to be_instance_of(ParentRubyObject)
    end

    it 'passes the object and count to blocks' do
      expect(parent_ruby_object.extra_fields).to eq (1..4).map { |i| "field #{i}" }
    end

    it 'sets the static value' do
      expect(parent_ruby_object.instance_variable_get(:@string_field)).to eq 'different content'
    end

    context "with on_init block" do
      subject { schematic.fabricate }

      context "using init_with" do
        let(:schematic) do
          Fabrication::Schematic::Definition.new('ClassWithInit') do
            on_init { init_with(:a, :b) }
          end
        end

        it "sends the return value of the block to the klass' initialize method" do
          expect(subject.arg1).to eq(:a)
          expect(subject.arg2).to eq(:b)
        end
      end

      context "not using init_with" do
        let(:schematic) do
          Fabrication::Schematic::Definition.new('ClassWithInit') do
            on_init { [ :a, :b ] }
          end
        end

        it "sends the return value of the block to the klass' initialize method" do
          expect(subject.arg1).to eq(:a)
          expect(subject.arg2).to eq(:b)
        end

      end
    end

    context "with initialize_with block" do
      subject { schematic.fabricate }

      context "using only raw values" do
        let(:schematic) do
          Fabrication::Schematic::Definition.new('ClassWithInit') do
            initialize_with { Struct.new(:arg1, :arg2).new(:fixed_value) }
          end
        end

        it "saves the return value of the block as instance" do
          expect(subject.arg1).to eq(:fixed_value)
          expect(subject.arg2).to eq(nil)
        end
      end

      context "using attributes inside block" do
        let(:schematic) do
           Fabrication::Schematic::Definition.new('ClassWithInit') do
             arg1 10
             initialize_with { Struct.new(:arg1, :arg2).new(arg1, arg1 + 10) }
          end
        end

        context "without override" do
          it "saves the return value of the block as instance" do
            expect(subject.arg1).to eq(10)
            expect(subject.arg2).to eq(20)
          end
        end

        context "with override" do
          subject { schematic.fabricate(arg1: 30) }
          it "saves the return value of the block as instance" do
            expect(subject.arg1).to eq(30)
            expect(subject.arg2).to eq(40)
          end
        end

      end
    end

    context "using an after_create hook" do
      let(:schematic) do
        Fabrication::Schematic::Definition.new('ParentRubyObject') do
          string_field 'something'
          after_create { |k| k.string_field.upcase! }
        end
      end

      it "calls after_create when generated with saving" do
        expect(schematic.fabricate.string_field).to eq 'SOMETHING'
      end

      it "does not call after_create when generated without saving" do
        expect(schematic.build.string_field).to eq 'something'
      end
    end

    context 'all the callbacks' do
      subject { schematic.build }
      let(:schematic) do
        Fabrication::Schematic::Definition.new('ParentRubyObject') do
          string_field ""
          after_build { |k| k.string_field += '1' }
          before_validation { |k| k.string_field += '2' }
          after_validation { |k| k.string_field += '3' }
        end
      end
      its(:string_field) { should == '1' }
    end

    context 'with custom generators' do
      before do
        Fabrication.configure do |config|
          config.generators << ImmutableGenerator
        end
      end

      after do
        Fabrication::Config.reset_defaults
      end

      it "uses custom generator" do
        user = Fabricate(:immutable_user, name: 'foo')
        expect(user.name).to eq('foo')
      end
    end
  end

  describe '#create' do
    context 'all the callbacks' do
      subject { schematic.fabricate }
      let(:schematic) do
        Fabrication::Schematic::Definition.new('ParentRubyObject') do
          string_field ""
          after_build { |k| k.string_field += '1' }
          before_validation { |k| k.string_field += '2' }
          after_validation { |k| k.string_field += '3' }
          before_save { |k| k.string_field += '4' }
          before_create { |k| k.string_field += '5' }
          after_create { |k| k.string_field += '6' }
          after_save { |k| k.string_field += '7' }
        end
      end
      its(:string_field) { should == '1234567' }
    end
  end

  describe "#persist" do
    let(:instance) { double }
    let(:generator) { Fabrication::Generator::Base.new(Object) }

    before { generator.send(:_instance=, instance) }

    it 'saves' do
      expect(instance).to receive(:save!)
      generator.send(:persist)
    end
  end

  describe 'robustness tests' do
    it 'maintains valid state on exceptions while building' do
      expect { Fabricate.build(:troublemaker, raise_exception: true) }.to raise_exception "Troublemaker exception"
      expect(Fabricate(:parent_ruby_object)).to be_persisted
    end
  end

end
