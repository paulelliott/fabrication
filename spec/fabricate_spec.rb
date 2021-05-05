require 'spec_helper'

describe Fabricate do
  describe '.times' do
    it 'fabricates an object X times' do
      objects = described_class.times(3, :parent_ruby_object)
      expect(objects.length).to eq 3
      expect(objects.all?(&:persisted?)).to be true
    end

    it 'delegates overrides and blocks properly' do
      object = described_class.times(1, :parent_ruby_object, string_field: 'different').first
      expect(object.string_field).to eql('different')

      object = described_class.times(1, :parent_ruby_object) { string_field 'other' }.first
      expect(object.string_field).to eql('other')
    end
  end

  describe '.build_times' do
    it 'fabricates an object X times' do
      objects = described_class.build_times(3, :parent_ruby_object)
      expect(objects.length).to eq 3
      expect(objects.all?(&:persisted?)).to be false
    end

    it 'delegates overrides and blocks properly' do
      object = described_class.build_times(1, :parent_ruby_object, string_field: 'different').first
      expect(object.string_field).to eql('different')

      object = described_class.build_times(1, :parent_ruby_object) { string_field 'other' }.first
      expect(object.string_field).to eql('other')
    end
  end

  describe '.attributes_for_times' do
    it 'fabricates an object X times' do
      objects = described_class.attributes_for_times(3, :parent_ruby_object)
      expect(objects.length).to eq 3
      expect(objects).to all be_a_kind_of(Hash)
    end

    it 'delegates overrides and blocks properly' do
      object = described_class.attributes_for_times(1, :parent_ruby_object, string_field: 'different').first
      expect(object[:string_field]).to eql('different')

      object = described_class.attributes_for_times(1, :parent_ruby_object) { string_field 'other' }.first
      expect(object[:string_field]).to eql('other')
    end
  end

  describe '.to_params', depends_on: :active_record do
    let(:as_params) { described_class.to_params(:parent_active_record_model_with_children) }

    it 'correctly serializes' do
      expect(as_params).to eq(
        'dynamic_field' => nil,
        'nil_field' => nil,
        'number_field' => 5,
        'string_field' => 'content',
        'false_field' => false,
        'extra_fields' => {},
        'child_active_record_models' => [
          { 'number_field' => 10 }, { 'number_field' => 10 }
        ]
      )
    end

    it 'is accessible as symbols' do
      expect(as_params[:number_field]).to eq(5)
      expect(as_params[:child_active_record_models].first[:number_field]).to eq(10)
    end
  end
end
