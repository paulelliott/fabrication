require 'spec_helper'

describe Fabrication::Generator::ActiveRecord do

  before(:all) { TestMigration.up }
  after(:all) { TestMigration.down }

  let(:schematic) do
    Fabrication::Schematic.new do
      name 'Company Name'
      city { |c| c.name.reverse.downcase.titleize }
      divisions(:count => 2) { |c, i| Fabricate(:division, :company => c, :name => "Division #{i}") }
    end
  end

  let(:generator) do
    Fabrication::Generator::ActiveRecord.new(Company, schematic)
  end

  context 'active record object' do

    let(:company) do
      generator.generate
    end

    before { company }

    it 'does not persist the divisions immediately' do
      Division.count.should == 0
    end

    it 'passes the object to blocks' do
      company.city.should == 'Eman Ynapmoc'
    end

    it 'passes the object and count to blocks' do
      company.divisions.map(&:name).should == ["Division 1", "Division 2"]
    end

    it 'persists the company upon creation' do
      Company.find_by_name('Company Name').should be
    end

    context 'upon accessing the divisions association' do

      let(:divisions) { company.divisions }

      it 'generates the divisions' do
        divisions.length.should == 2
      end

      it 'persists the divisions' do
        divisions
        Division.find_all_by_company_id(company.id).count.should == 2
      end

      it 'can load the divisions from the database' do
        company.reload.divisions.length.should == 2
      end

    end

  end

  context 'with the build option' do

    let(:company) { Fabricate.build(:company, :name => "Epitaph") }

    it 'creates the record' do
      company.name.should == 'Epitaph'
    end

    it 'does not save it to the database' do
      Company.count.should == 0
    end

  end

end
