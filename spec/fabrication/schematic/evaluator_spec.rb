require 'spec_helper'

describe Fabrication::Schematic::Evaluator do
  let(:definition) { Fabrication::Schematic::Definition.new(ParentRubyObject) }
  let(:evaluator) { described_class.new }

  describe 'attribute handling' do
    let(:first_attribute) { definition.attributes.first }

    before { evaluator.process(definition, &block) }

    context 'without a count' do
      let(:block) do
        proc do
          dynamic_field { Fabricate(:child_ruby_object) }
        end
      end

      it 'stores the name' do
        expect(first_attribute.name).to eq(:dynamic_field)
      end

      it 'the attribute produces the correct value' do
        expect(first_attribute.processed_value({})).to be_kind_of(ChildRubyObject)
      end
    end

    context 'with a count' do
      let(:block) do
        proc do
          dynamic_field(count: 2) { Fabricate(:child_ruby_object) }
        end
      end

      it 'stores the name' do
        expect(first_attribute.name).to eq(:dynamic_field)
      end

      it 'the attribute produces the correct value' do
        expect(first_attribute.processed_value({}).first).to be_kind_of(ChildRubyObject)
      end
    end
  end
end
