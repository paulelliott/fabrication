require 'spec_helper'

describe Fabrication::Generator::ActiveRecord do

  before(:all) { TestMigration.up }
  after(:all) { TestMigration.down }

  context 'active record object' do

    let(:company) do
      Fabrication::Generator::ActiveRecord.new(Company) do
        name 'Company Name'
        divisions { |c| [Fabricate(:division, :company => c)] }
      end.generate({:name => 'Something'})
    end

    before(:all) do
      Fabricator(:division) do
        name "Division Name"
      end
    end

    before { company }

    it 'persists the company upon creation' do
      Company.find_by_name('Something').should be
    end

    it 'does not persist the divisions immediately' do
      Division.count.should == 0
    end

    context 'upon accessing the divisions association' do

      let(:divisions) { company.divisions }

      it 'generates the divisions' do
        divisions.length.should == 1
      end

      it 'persists the divisions' do
        divisions
        Division.find_all_by_company_id(company.id).count.should == 1
      end

      it 'can load the divisions from the database' do
        company.reload.divisions.length.should == 1
      end

    end

  end

end
