require 'spec_helper'

describe Fabrication::Schematic::Evaluator do
  let(:definition) { Fabrication::Schematic::Definition.new(ParentRubyObject) }
  let(:evaluator) { Fabrication::Schematic::Evaluator.new }

  describe 'attribute handling' do
    subject { definition.attributes.first }
    before { evaluator.process(definition, &block) }

    context 'without a count' do
      let(:block) do
        proc do
          dynamic_field { Fabricate(:child_ruby_object) }
        end
      end
      its(:name) { should == :dynamic_field }
      it 'the attribute produces the correct value' do
        expect(subject.processed_value({})).to be_kind_of(ChildRubyObject)
      end
    end

    context 'with a count' do
      let(:block) do
        proc do
          dynamic_field(count: 2) { Fabricate(:child_ruby_object) }
        end
      end
      its(:name) { should == :dynamic_field }
      it 'the attribute produces the correct value' do
        expect(subject.processed_value({}).first).to be_kind_of(ChildRubyObject)
      end
    end
  end
end
