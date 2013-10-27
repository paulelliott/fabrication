require 'spec_helper'

describe Fabricate do
  describe ".times" do
    it "fabricates an object X times" do
      expect {
        expect(Fabricate.times(3, :company)).to have(3).elements
      }.to change(Company, :count).by(3)
    end

    it "delegates overrides and blocks properly" do
      company = Fabricate.times(1, :company, display: 'different').first
      expect(company.display).to eql('different')

      company = Fabricate.times(1, :company) { display 'other' }.first
      expect(company.display).to eql('other')
    end
  end

  describe ".build_times" do
    it "fabricates an object X times" do
      expect {
        expect(Fabricate.build_times(3, :company)).to have(3).elements
      }.to change(Company, :count).by(0)
    end

    it "delegates overrides and blocks properly" do
      company = Fabricate.times(1, :company, display: 'different').first
      expect(company.display).to eql('different')

      company = Fabricate.times(1, :company) { display 'other' }.first
      expect(company.display).to eql('other')
    end
  end

  describe ".to_params" do
    subject { Fabricate.to_params(:parent_active_record_model_with_children) }

    it do
      should == {
        'dynamic_field' => nil,
        'nil_field' => nil,
        'number_field' => 5,
        'string_field' => 'content',
        'false_field' => false,
        'extra_fields' => {},
        'child_active_record_models' => [
          { 'number_field' => 10 }, { 'number_field' => 10 }
        ]
      }
    end

    it 'is accessible as symbols' do
      expect(subject['number_field']).to eq(5)
      expect(subject['child_active_record_models'].first['number_field']).to eq(10)
    end
  end
end
