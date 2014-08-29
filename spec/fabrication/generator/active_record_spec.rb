require 'spec_helper'

describe Fabrication::Generator::ActiveRecord, depends_on: :active_record do

  describe ".supports?" do
    subject { Fabrication::Generator::ActiveRecord }

    it "returns true for active record objects" do
      expect(subject.supports?(ParentActiveRecordModel)).to be true
    end

    it "returns false for non-active record objects" do
      expect(subject.supports?(ParentRubyObject)).to be false
    end
  end

  describe "#persist" do
    let(:instance) { double }
    let(:generator) { Fabrication::Generator::ActiveRecord.new(ParentActiveRecordModel) }

    before { generator.send(:_instance=, instance) }

    it "saves" do
      expect(instance).to receive(:save!)
      generator.send(:persist)
    end
  end

  describe "#create" do

    let(:attributes) do
      Fabrication::Schematic::Definition.new(ParentActiveRecordModel) do
        string_field 'Different Content'
        number_field { |attrs| attrs[:string_field].length }
        child_active_record_models(count: 2) { |attrs, i| ChildActiveRecordModel.new(number_field: i) }
      end.attributes
    end

    let(:generator) { Fabrication::Generator::ActiveRecord.new(ParentActiveRecordModel) }
    let!(:parent_active_record_model) { generator.create(attributes, {}) }
    let(:child_active_record_models) { parent_active_record_model.child_active_record_models }

    it 'passes the object to blocks' do
      expect(parent_active_record_model.number_field).to eq 17
    end

    it 'passes the object and count to blocks' do
      expect(child_active_record_models.map(&:number_field)).to eq [1, 2]
    end

    it 'persists the company upon creation' do
      expect(ParentActiveRecordModel.where(string_field: 'Different Content').count).to eq 1
    end

    it 'generates the divisions' do
      expect(child_active_record_models.count).to eq 2
    end

    it 'persists the divisions' do
      expect(ChildActiveRecordModel.where(parent_active_record_model_id: parent_active_record_model.id).count).to eq 2
    end

  end

end
