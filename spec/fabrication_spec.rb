require 'spec_helper'

describe Fabrication do

  context 'with an active record object' do

    before(:all) { TestMigration.up }
    after(:all) { TestMigration.down }

    before do
      Fabricator(:company) do
        name { Faker::Company.name }
      end
    end

    let(:company) { Fabricate(:company) }

    it 'generates field blocks immediately' do
      company.name.should be
    end
    it 'overrides associations'
  end

end
