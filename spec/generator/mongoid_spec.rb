require 'spec_helper'

describe Fabrication::Generator::Mongoid do

  before(:all) { TestMigration.up }
  after(:all) { TestMigration.down }

  context 'mongoid object' do

    let(:company) do
      Fabrication::Generator::Mongoid.new(Author) do
        name 'Name'
      end.generate({:name => 'Something'})
    end

    before { company }

    it 'persists the author upon creation' do
      Author.where(:name => 'Something').first.should be
    end

  end

end
