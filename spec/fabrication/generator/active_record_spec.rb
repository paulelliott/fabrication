require 'spec_helper'

describe Fabrication::Generator::ActiveRecord do

  describe ".supports?" do
    subject { Fabrication::Generator::ActiveRecord }
    it "returns true for active record objects" do
      subject.supports?(Company).should be_true
    end
    it "returns false for non-active record objects" do
      subject.supports?(Person).should be_false
    end
  end

  describe "#after_generation" do
    let(:instance) { mock(:instance) }
    let(:generator) { Fabrication::Generator::ActiveRecord.new(Company) }

    before { generator.send(:__instance=, instance) }

    it "saves with a true save flag" do
      instance.should_receive(:save!)
      generator.send(:after_generation, {:save => true})
    end

    it "does not save without a true save flag" do
      instance.should_not_receive(:save)
      generator.send(:after_generation, {})
    end
  end

  describe "#generate" do

    let(:attributes) do
      Fabrication::Schematic::Definition.new(Company) do
        name 'Company Name'
        city { |attrs| attrs[:name].downcase }
        divisions(count: 2) { |attrs, i| Division.new(name: "Division #{i}") }
      end.attributes
    end

    let(:generator) { Fabrication::Generator::ActiveRecord.new(Company) }
    let!(:company) { generator.generate({:save => true}, attributes) }
    let(:divisions) { company.divisions }

    it 'passes the object to blocks' do
      company.city.should == 'company name'
    end

    it 'passes the object and count to blocks' do
      company.divisions.map(&:name).should == ["Division 1", "Division 2"]
    end

    it 'persists the company upon creation' do
      Company.find_by_name('Company Name').should be
    end


    it 'generates the divisions' do
      divisions.length.should == 2
    end

    it 'persists the divisions' do
      Division.find_all_by_company_id(company.id).count.should == 2
    end

  end

end
