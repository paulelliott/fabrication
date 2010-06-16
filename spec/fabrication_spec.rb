require 'spec_helper'

describe Fabrication do

  context 'with an active record object' do

    before(:all) { TestMigration.up }
    after(:all) { TestMigration.down }

    before do
      Fabricator(:company) do
        name { Faker::Company.name }
        divisions(:force) { [Fabricate(:division)] }
      end

      Fabricator(:division) do
        name "Awesome Division"
      end
    end

    let(:company) { Fabricate(:company) }

    it 'generates field blocks immediately' do
      company.name.should be
    end

    it 'generates associations immediately when forced' do
      Division.find_all_by_company_id(company.id).count.should == 1
    end

    it 'overrides associations' do
      Fabricate(:company, :divisions => []).divisions.should == []
    end
  end

end
