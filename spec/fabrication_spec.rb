require 'spec_helper'

describe Fabricate do
  context "times" do
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
end
